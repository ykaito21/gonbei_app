import 'package:flutter/material.dart';
import '../../core/providers/profile_edit_screen_provider.dart';
import '../global/extensions.dart';
import '../shared/widgets/cached_image.dart';

class AvatarDisplay extends StatelessWidget {
  const AvatarDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileEditScreenProvider =
        context.provider<ProfileEditScreenProvider>(listen: true);
    if (profileEditScreenProvider.avatarImageFile == null) {
      if (profileEditScreenProvider.user.imageUrl.isNotEmpty) {
        return CachedImage(
          imageUrl: profileEditScreenProvider.user.imageUrl,
        );
      } else {
        return Image.asset(
          'assets/images/user_avatar_placeholder.png',
          fit: BoxFit.cover,
        );
      }
    } else {
      return Image.file(
        profileEditScreenProvider.avatarImageFile,
        fit: BoxFit.cover,
      );
    }
  }
}
