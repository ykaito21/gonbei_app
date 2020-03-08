import 'package:flutter/material.dart';
import '../../core/models/cart_model.dart';
import '../../core/models/product_model.dart';
import '../shared/widgets/cached_image.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import 'column_quantity_counter.dart';

class CartCard extends StatelessWidget {
  final CartModel cartItem;
  const CartCard({
    Key key,
    @required this.cartItem,
  })  : assert(cartItem != null),
        super(key: key);

  ProductModel get productItem => cartItem.productItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 60.0,
              width: 80.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
                child: CachedImage(imageUrl: productItem.imageUrl),
              ),
            ),
            ColumnQuantityCounter(
              cartItem: cartItem,
            ),
            Container(
              width: 100.0,
              child: Text(
                productItem.name,
                style: StyleList.baseSubtitleTextStyle,
              ),
            ),
          ],
        ),
        Padding(
          padding: StyleList.leftPadding10,
          child: Text(
            context.localizePrice(productItem.price),
            style: StyleList.baseSubtitleTextStyle
                .copyWith(color: context.accentColor),
          ),
        ),
      ],
    );
  }
}
