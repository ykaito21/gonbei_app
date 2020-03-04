import 'package:flutter/material.dart';
import '../../global/routes/route_path.dart';
import '../../global/style_list.dart';
import '../../global/extensions.dart';

import 'base_button.dart';

class UnauthenticatedCard extends StatelessWidget {
  const UnauthenticatedCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: StyleList.allPadding10,
      child: BaseButton(
        buttonText: context.translate('signupOrLogin'),
        onPressed: () =>
            context.pushNamed(RoutePath.authScreen, rootNavigator: true),
      ),
    );
  }
}
