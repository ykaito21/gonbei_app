import 'package:flutter/material.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/widgets/base_button.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({Key key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    final bool confirmation = await PlatformAlertDialog(
      title: context.translate('signOut'),
      content: context.translate('wantToSignOut'),
      defaultActionText: context.translate('yes'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
    try {
      if (confirmation) {
        await context.provider<AuthProvider>().signOut();
        context.pop();
      }
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: context.translate('error'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.provider<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('accountSettings'),
          style: StyleList.baseSubtitleTextStyle,
        ),
      ),
      body: Padding(
        padding: StyleList.allPadding10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BaseButton(
              buttonText: themeProvider.isLight
                  ? context.translate('dark')
                  : context.translate('light'),
              onPressed: () => themeProvider.changeTheme(),
            ),
            BaseButton(
              buttonText: context.translate('signOut'),
              onPressed: () async => await _signOut(context),
            ),
          ],
        ),
      ),
    );
  }
}
