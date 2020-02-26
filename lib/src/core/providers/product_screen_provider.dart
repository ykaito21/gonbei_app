import 'package:flutter/widgets.dart';
// import 'package:gonbei_app/src/core/models/category_model.dart';
// import 'package:gonbei_app/src/core/models/product_model.dart';

import 'base_provider.dart';

class ProductScreenProvider extends BaseProvider {
  // List<CategoryModel> _categoryList = [];
  // List<ProductModel> _productList = [];
  int _currentCategoryIndex = 0;
  PageController _productPageController = PageController();

  int get currentCategoryIndex => _currentCategoryIndex;
  // String get currentCategoryName => _categoryList[_currentCategoryIndex].name;
  PageController get productPageController => _productPageController;

  ProductScreenProvider() {
    // setViewState(ViewState.Busy);
  }

  // set categoryList(List<CategoryModel> value) {
  //   print(value);
  //   if (_categoryList != value) {
  //     _categoryList = value;
  //     updateViewState();
  //   }
  // }

  // set productList(List<ProductModel> value) {
  //   if (_productList != value) {
  //     _productList = value;
  //     updateViewState();
  //   }
  // }

  // void updateViewState() {
  //   if (_categoryList.isNotEmpty && _productList.isNotEmpty)
  //     setViewState(ViewState.Retrieved);
  // }

  // List<ProductModel> getCategoryProductList(String categoryId) {
  //   return _productList
  //       .where((product) => product.categoryId == categoryId)
  //       .toList();
  // }

  void changeCurrentCategoryIndex(int newCategoryIndex) {
    _currentCategoryIndex = newCategoryIndex;
    notifyListeners();
  }

  void changeProductListPage() {
    if (_currentCategoryIndex - _productPageController.page < -1 ||
        _currentCategoryIndex - _productPageController.page > 1) {
      _productPageController.jumpToPage(
        _currentCategoryIndex,
      );
    } else {
      _productPageController.animateToPage(
        _currentCategoryIndex,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 200),
      );
    }
  }
}
