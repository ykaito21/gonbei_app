import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/product_model.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/product_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/style_list.dart';

import 'product_card.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;
    final productScreenProvider =
        Provider.of<ProductScreenProvider>(context, listen: false);
    final Function changeCurrentCategoryIndex =
        productScreenProvider.changeCurrentCategoryIndex;
    final PageController productPageController =
        productScreenProvider.productPageController;

    return PageView.builder(
      controller: productPageController,
      onPageChanged: changeCurrentCategoryIndex,
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final category = categoryList[index];
        final productList = Provider.of<ProductProvider>(context, listen: false)
            .getCategoryProductList(category.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: StyleList.verticalHorizontalpadding1020,
              child: Text(
                category.name,
                style: StyleList.baseTitleTextStyle,
              ),
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2 / 3,
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final ProductModel product = productList[index];
                    return ProductCard(
                      productItem: product,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
