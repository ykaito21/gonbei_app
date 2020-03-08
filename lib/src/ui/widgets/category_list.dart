import 'package:flutter/material.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import 'category_card.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key key}) : super(key: key);

  void _onTapCategory(BuildContext context, int index) {
    final productScreenProvider = context.provider<ProductScreenProvider>();
    productScreenProvider.changeCurrentCategoryIndex(index);
    productScreenProvider.changeProductListPage();
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = context.provider<CategoryProvider>().categoryList;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categoryList.length,
      itemBuilder: (context, index) {
        final categoryItem = categoryList[index];
        return GestureDetector(
          onTap: () => _onTapCategory(context, index),
          child: Padding(
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
