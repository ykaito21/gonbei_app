import 'package:flutter/material.dart';
import '../global/routes/route_path.dart';
import '../global/extensions.dart';

class ProfileItemList extends StatelessWidget {
  const ProfileItemList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _itemTile(
            context: context,
            icon: Icons.edit,
            titleText: context.translate('editProfile'),
            onTap: () =>
                Navigator.pushNamed(context, RoutePath.profileEditScreen),
          ),
          _itemTile(
            context: context,
            icon: Icons.receipt,
            titleText: context.translate('orderHistory'),
            onTap: () =>
                Navigator.pushNamed(context, RoutePath.orderRecordScreen),
          ),
          _itemTile(
            context: context,
            icon: Icons.payment,
            titleText: context.translate('paymentMethods'),
            onTap: () =>
                Navigator.pushNamed(context, RoutePath.paymentInfoScreen),
          ),
          _itemTile(
            context: context,
            icon: Icons.settings,
            titleText: context.translate('accountSettings'),
            onTap: () =>
                Navigator.pushNamed(context, RoutePath.accountSettingScreen),
          ),
        ],
      ),
    );
  }

  Widget _itemTile({
    @required BuildContext context,
    @required IconData icon,
    @required String titleText,
    @required Function onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: context.accentColor,
      ),
      title: Text(
        titleText,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
