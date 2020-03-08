import 'package:flutter/foundation.dart';

class ApiPath {
  static String categories() => 'categories';
  static String products() => 'products';
  static String user({@required String userId}) => 'users/$userId';
  static String cart({@required String userId}) => 'users/$userId/cart';
  static String cartItem(
          {@required String userId, @required String cartItemId}) =>
      'users/$userId/cart/$cartItemId';
  static String orders({@required String userId}) => 'users/$userId/orders';
  static String orderItem(
          {@required String userId, @required String orderItemId}) =>
      'users/$userId/orders/$orderItemId';
  static String userAvatar({@required userId}) => 'users/$userId/avatar.jpg';

// Stripe
  static String stripeSources({@required String userId}) =>
      'stripe/$userId/sources';
  static String stripeInfo({@required String userId}) => 'stripe/$userId';
}
