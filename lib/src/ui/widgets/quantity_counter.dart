import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/product_detail_screen_provider.dart';
import '../global/style_list.dart';

class QuantityCounter extends StatelessWidget {
  const QuantityCounter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productDetailScreenProvider =
        Provider.of<ProductDetailScreenProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: productDetailScreenProvider.decrement,
          child: Icon(
            Icons.remove,
            color: Theme.of(context).accentColor,
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Consumer<ProductDetailScreenProvider>(
            builder: (context, provider, child) {
              return Text(
                "${provider.quantity}",
                style: StyleList.baseSubtitleTextStyle,
              );
            },
          ),
        ),
        FlatButton(
          onPressed: productDetailScreenProvider.increment,
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          color: Theme.of(context).accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ],
    );
  }
}
