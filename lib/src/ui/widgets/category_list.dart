import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/category_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/style_list.dart';
import 'category_card.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key key}) : super(key: key);

  void _onTap(BuildContext context, int index) {
    final productScreenProvider =
        Provider.of<ProductScreenProvider>(context, listen: false);
    final changeCurrentCategoryIndex =
        productScreenProvider.changeCurrentCategoryIndex;
    final changeProductListPage = productScreenProvider.changeProductListPage;
    changeCurrentCategoryIndex(index);
    changeProductListPage();
  }

  @override
  Widget build(BuildContext context) {
    final categoryList =
        Provider.of<CategoryProvider>(context, listen: false).categoryList;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final categoryItem = categoryList[index];
        return GestureDetector(
          onTap: () => _onTap(context, index),
          child: Container(
            padding: StyleList.horizontalPadding5,
            child: CategoryCard(
              categoryItem: categoryItem,
            ),
          ),
        );
      },
    );
  }
}
