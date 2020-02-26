import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';

import '../global/style_list.dart';
import '../global/routes/route_path.dart';
import '../shared/widgets/cached_image.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productItem;
  const ProductCard({
    Key key,
    @required this.productItem,
  })  : assert(productItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  // height: 90.0,
                  child: Hero(
                    tag: productItem.id,
                    child: CachedImage(imageUrl: productItem.imageUrl),
                  ),
                ),
              ),
              StyleList.verticalBox10,
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      productItem.name,
                      textAlign: TextAlign.center,
                      style: StyleList.smallBoldTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: StyleList.verticalBox10,
                    ),
                    Text(
                      StyleList.localizedPrice(context, productItem.price),
                      textAlign: TextAlign.center,
                      style: StyleList.smallBoldTextStyle.copyWith(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RoutePath.productDetailScreen,
                  arguments: productItem,
                );
              },
              splashColor: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
        ],
      ),
    );
  }
}
