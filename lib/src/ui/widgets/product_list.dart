import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/product_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  const ProductList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final categoryList = context.provider<CategoryProvider>().categoryList;
    final productScreenProvider = context.provider<ProductScreenProvider>();

    return PageView.builder(
      controller: productScreenProvider.productPageController,
      onPageChanged: productScreenProvider.changeCurrentCategoryIndex,
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final category = categoryList[index];
        final productList = context
            .provider<ProductProvider>()
            .getCategoryProductList(category.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: StyleList.verticalHorizontalpadding1020,
              child: Text(
                category.name,
                style: StyleList.baseTitleTextStyle,
              ),
            ),
            Expanded(
              child: Container(
                child: GridView.builder(
                  padding: StyleList.horizontalPadding10,
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
