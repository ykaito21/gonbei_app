import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'product_model.dart';

class CartModel extends Equatable {
  final String id;
  final int quantity;
  final ProductModel productItem;

  CartModel({
    @required this.id,
    @required this.quantity,
    @required this.productItem,
  });

  factory CartModel.fromFirestore(Map snapshot, String id) {
    return CartModel(
      id: id ?? '',
      quantity: snapshot['quantity'] ?? 0,
      productItem: ProductModel(
        id: snapshot['productId'] ?? '',
        name: snapshot['name'] ?? '',
        description: snapshot['description'] ?? '',
        imageUrl: snapshot['imageUrl'] ?? '',
        price: snapshot['price'] ?? 0,
        categoryId: snapshot['categoryId'] ?? '',
      ),
    );
  }

  Map<String, dynamic> toMapForeFirestore() {
    return {
      // "id": id,
      "quantity": quantity,
      "productId": productItem.id,
      "name": productItem.name,
      "description": productItem.description,
      "imageUrl": productItem.imageUrl,
      "price": productItem.price,
      "categoryId": productItem.categoryId,
      "createdAt": DateTime.now(),
    };
  }

  @override
  List<Object> get props => [id, quantity, productItem];

  @override
  bool get stringify => true;
}
