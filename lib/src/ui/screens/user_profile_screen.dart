import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/providers/user_provider.dart';
import '../../core/models/user_model.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/base_app_bar.dart';
import '../shared/widgets/unauthenticated_card.dart';
import '../shared/widgets/stream_wrapper.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_item_list.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      //* could be consumer and listen change but changing tab rebuild screen anyway
      body: context.provider<FirebaseUser>(listen: true) == null
          ? UnauthenticatedCard()
          //* maybe doesn't have to use stream cuz always rebuild when change user info
          : StreamWrapper<UserModel>(
              stream: context.provider<UserProvider>().streamUser,
              onError: (BuildContext context, _) => StyleList.errorViewState(
                  context.translate('error'), StyleList.baseSubtitleTextStyle),
              onSuccess: (BuildContext context, UserModel user) {
                return Padding(
                  padding: StyleList.allPadding10,
                  child: Column(
                    children: <Widget>[
                      ProfileCard(user: user),
                      StyleList.verticalBox10,
                      Expanded(
                        child: ProfileItemList(),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
