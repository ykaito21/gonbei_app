import 'package:flutter/material.dart';
import 'package:gonbei_app/src/app_localizations.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(AppLocalizations.of(context).translate('note')),
      ),
    );
  }
}
