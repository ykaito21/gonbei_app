import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/providers/user_provider.dart';
import '../../core/providers/profile_edit_screen_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_bottom_sheet.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/widgets/base_text_field.dart';
import '../shared/widgets/base_flat_button.dart';
import '../shared/widgets/base_button.dart';
import '../widgets/avatar_display.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({Key key}) : super(key: key);

  Future<ImageSource> _chooseSource(BuildContext context) async {
    final res = await PlatformBottomSheet(
      title: context.translate('editProfilePicture'),
      actionTextList: [
        context.translate('takePhoto'),
        context.translate('photoLibrary')
      ],
      cancelActionText: context.translate('cancel'),
    ).show(context);
    if (res == null || res == context.translate('cancel')) {
      return null;
    } else {
      if (res == context.translate('takePhoto')) {
        return ImageSource.camera;
      } else {
        return ImageSource.gallery;
      }
    }
  }

  Future<void> _onTapAvatar(BuildContext context,
      ProfileEditScreenProvider profileEditScreenProvider) async {
    final source = await _chooseSource(context);
    try {
      await profileEditScreenProvider.pickAvatarImage(source);
    } catch (e) {
      if (e.code == 'photo_access_denied' || e.code == 'camera_access_denied') {
        PlatformAlertDialog(
          title: context.translate('needPermission'),
          content: context.translate('pleaseAllowAccess'),
          defaultActionText: 'OK',
        ).show(context);
      } else {
        PlatformExceptionAlertDialog(
          title: context.translate('error'),
          exception: e,
          context: context,
        ).show(context);
      }
    }
  }

  Future<void> _onPressedSave(BuildContext context,
      ProfileEditScreenProvider profileEditScreenProvider) async {
    context.unfocus;
    try {
      await profileEditScreenProvider.saveProfile();
      Navigator.pop(context);
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: context.translate('error'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  Future<void> _onPressedDelete(BuildContext context,
      ProfileEditScreenProvider profileEditScreenProvider) async {
    context.unfocus;
    final bool confirmation = await PlatformAlertDialog(
      title: context.localizeAlertTtile(
          context.translate('profile'), 'alertDeleteTitle'),
      content: context.translate('alertDeleteProfile'),
      defaultActionText: context.translate('yes'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
    if (confirmation) {
      try {
        await profileEditScreenProvider.resetProfile();
        context.pop();
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: context.translate('error'),
          exception: e,
          context: context,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // could be pass through as normal valiable
    final currentUser = context.provider<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('editProfile'),
          style: StyleList.baseSubtitleTextStyle,
        ),
      ),
      body: ChangeNotifierProvider<ProfileEditScreenProvider>(
        create: (context) => ProfileEditScreenProvider(user: currentUser),
        child: Consumer<ProfileEditScreenProvider>(
            builder: (context, profileEditScreenProvider, child) {
          final user = profileEditScreenProvider.user;
          return ModalProgressHUD(
            inAsyncCall: profileEditScreenProvider.isBusy,
            child: GestureDetector(
              onTap: () => context.unfocus,
              child: Container(
                //* for unfocus
                color: Colors.transparent,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: StyleList.allPadding10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: StyleList.verticalPadding10,
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => _onTapAvatar(
                                    context, profileEditScreenProvider),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    // this column is to not streach container
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 100.0,
                                          width: 100.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: user.imageUrl.isNotEmpty
                                                ? Border.all(
                                                    color: context.accentColor,
                                                    width: 2.0,
                                                  )
                                                : null,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: AvatarDisplay(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    StyleList.verticalBox10,
                                    BaseTextField(
                                      labelText: context.translate('username'),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: context.accentColor,
                                      ),
                                      textInputAction: TextInputAction.done,
                                      controller: profileEditScreenProvider
                                          .usernameController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        BaseButton(
                          buttonText: context.translate('save'),
                          onPressed: () => _onPressedSave(
                              context, profileEditScreenProvider),
                        ),
                        BaseFlatButton(
                          buttonText: context.translate('delete'),
                          onPressed: () => _onPressedDelete(
                              context, profileEditScreenProvider),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
