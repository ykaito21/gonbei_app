import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
import '../global/routes/route_path.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/widgets/cached_image.dart';

class ProfileCard extends StatelessWidget {
  final UserModel user;
  const ProfileCard({
    Key key,
    @required this.user,
  })  : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = context.provider<UserProvider>().user;
    return GestureDetector(
      onTap: () => context.pushNamed(RoutePath.profileEditScreen),
      child: Padding(
        padding: StyleList.verticalPadding10,
        child: Column(
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
                borderRadius: BorderRadius.circular(50.0),
                child: user.imageUrl.isNotEmpty
                    ? CachedImage(
                        imageUrl: user.imageUrl,
                      )
                    : Image.asset(
                        'assets/images/user_avatar_placeholder.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            StyleList.verticalBox10,
            Text(
              user.name.isNotEmpty ? user.name : context.translate('gonbei'),
              style: StyleList.mediumBoldTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
