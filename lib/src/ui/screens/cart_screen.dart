import 'package:flutter/material.dart';

import '../../app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(AppLocalizations.of(context).translate('edit')),
      ),
    );
  }
}
