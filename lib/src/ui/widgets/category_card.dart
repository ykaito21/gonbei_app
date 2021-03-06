import 'package:flutter/material.dart';
import '../../core/models/category_model.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/extensions.dart';
import '../shared/widgets/cached_image.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel categoryItem;

  const CategoryCard({
    Key key,
    @required this.categoryItem,
  })  : assert(categoryItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryList = context.provider<CategoryProvider>().categoryList;
    final currentCategoryIndex = context
        .provider<ProductScreenProvider>(listen: true)
        .currentCategoryIndex;
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: Container(
        width: 100.0,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CachedImage(
                imageUrl: categoryItem.imageUrl,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 200),
                height: categoryItem == categoryList[currentCategoryIndex]
                    ? 100.0
                    : 30.0,
                width: 100.0,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    )),
                child: Center(
                  child: Text(
                    categoryItem.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
