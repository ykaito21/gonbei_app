import 'package:flutter/material.dart';

import '../global/extensions.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(context.translate('edit')),
      ),
    );
  }
}
