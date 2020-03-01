import 'package:flutter/widgets.dart';

import 'base_provider.dart';

class ProductScreenProvider extends BaseProvider {
  int _currentCategoryIndex = 0;
  PageController _productPageController = PageController();

  int get currentCategoryIndex => _currentCategoryIndex;
  PageController get productPageController => _productPageController;

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
