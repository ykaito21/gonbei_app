import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';

import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../services/database_service.dart';
import '../services/api_path.dart';
import 'base_provider.dart';

class CartProvider extends BaseProvider {
  FirebaseUser _currentUser;
  final _dbService = DatabaseService.instance;
  final _cartSubject = BehaviorSubject<List<CartModel>>.seeded([]);
  final random = Random();
  Stream<List<CartModel>> get streamCart => _cartSubject.stream;
  List<CartModel> get cart => _cartSubject.value;

  set currentUser(FirebaseUser value) {
    if (_currentUser != value) {
      _currentUser = value;
      if (_currentUser != null)
        _initCart()
            .listen(_cartSubject.add)
            .onError((error) => _cartSubject.add([]));
    }
  }

  @override
  dispose() {
    _cartSubject.close();
    super.dispose();
  }

  int totalPrice() {
    return cart.fold(
      0,
      (total, item) => total + (item.quantity * item.productItem.price),
    );
  }

  int totalQuantity() {
    return cart.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  Stream<List<CartModel>> _initCart() {
    // if (_currentUser != null) {
    final Stream<QuerySnapshot> res = _dbService.streamDataCollection(
      path: ApiPath.cart(userId: _currentUser.uid),
      orderBy: 'createdAt',
      descending: true,
    );
    return res.map(
      (list) {
        final List<CartModel> cart = list.documents
            .map(
              (doc) => CartModel.fromFirestore(doc.data, doc.documentID),
            )
            .toList();
        return cart;
      },
    );
    // }
    // return null;
  }

  Future<void> addCartItem(
      {@required ProductModel productItem, @required int quantity}) async {
    final checkProduct =
        cart.where((cartItem) => cartItem.productItem == productItem);
    try {
      if (checkProduct.isEmpty) {
        final newCartItem = CartModel(
          id: 'NEW_ITEM',
          quantity: quantity,
          productItem: productItem,
        );
        await _dbService.addDocument(
          path: ApiPath.cart(userId: _currentUser.uid),
          data: newCartItem.toMapForeFirestore(),
        );
      } else {
        final existingCartItem = checkProduct.first;
        await _dbService.updateDocument(
          path: ApiPath.cartItem(
              userId: _currentUser.uid, cartItemId: existingCartItem.id),
          data: {
            "quantity": existingCartItem.quantity + quantity,
          },
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateCartItem({
    @required CartModel cartItem,
    @required bool isIncrement,
  }) async {
    try {
      if (isIncrement) {
        await _dbService.updateDocument(
          path: ApiPath.cartItem(
              userId: _currentUser.uid, cartItemId: cartItem.id),
          data: {
            "quantity": FieldValue.increment(1),
          },
        );
      } else {
        await _dbService.updateDocument(
          path: ApiPath.cartItem(
              userId: _currentUser.uid, cartItemId: cartItem.id),
          data: {
            "quantity": FieldValue.increment(-1),
          },
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeCartItem(CartModel cartItem) async {
    try {
      await _dbService.removeDocument(
        path:
            ApiPath.cartItem(userId: _currentUser.uid, cartItemId: cartItem.id),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

//* can be improve to use transaction and batch
  Future<int> convertToOrder() async {
    setViewState(ViewState.Busy);
    final code = random.nextInt(9000) + 1000;
    final newOrder = OrderModel(
      id: 'NEW_ORDER',
      price: totalPrice(),
      quantity: totalQuantity(),
      code: code.toString(),
      date: DateTime.now(),
      status: 'PENDING',
      cart: cart,
    );
    try {
      // add order
      await _dbService.addDocument(
        path: ApiPath.orders(userId: _currentUser.uid),
        data: newOrder.toMapForFirestore(),
      );
      // get all cart items path
      final pathList = cart
          .map((cartItem) => ApiPath.cartItem(
              userId: _currentUser.uid, cartItemId: cartItem.id))
          .toList();
      // remove all cart items with transaction
      await _dbService.removeAllDocument(pathList: pathList);
      setViewState(ViewState.Retrieved);
      return code;
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }
}
