import 'package:gonbei_app/src/core/models/product_model.dart';

import 'base_provider.dart';

class ProductDetailScreenProvider extends BaseProvider {
  int _quantity = 1;
  int get quantity => _quantity;

  void increment() {
    if (_quantity < 20) {
      _quantity++;
      notifyListeners();
    }
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
}
