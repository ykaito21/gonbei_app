import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/product_detail_screen_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';

class RowQuantityCounter extends StatelessWidget {
  const RowQuantityCounter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productDetailScreenProvider =
        context.provider<ProductDetailScreenProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: productDetailScreenProvider.decrement,
          child: Icon(
            Icons.remove,
            color: context.accentColor,
            size: 32,
          ),
          color: context.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: context.accentColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Consumer<ProductDetailScreenProvider>(
            builder: (context, productDetailScreenProvider, child) {
              return Text(
                "${productDetailScreenProvider.quantity}",
                style: StyleList.mediumBoldTextStyle,
              );
            },
          ),
        ),
        FlatButton(
          onPressed: productDetailScreenProvider.increment,
          child: Icon(
            Icons.add,
            color: context.primaryColor,
            size: 32,
          ),
          color: context.accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: context.accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
