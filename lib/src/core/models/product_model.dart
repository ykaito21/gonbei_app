import 'package:flutter/foundation.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int price;
  final String categoryId;

  ProductModel({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.categoryId,
  });

  factory ProductModel.fromFirestore(Map snapshot, String id) {
    return ProductModel(
      id: id ?? '',
      name: snapshot['name'] ?? '',
      description: snapshot['description'] ?? '',
      imageUrl: snapshot['imageUrl'] ?? '',
      price: snapshot['price'] ?? 0,
      categoryId: snapshot['categoryId'] ?? '',
    );
  }

  @override
  String toString() {
    return 'id: $id, name: $name, description: $imageUrl, imageUrl: $imageUrl, price: $price, categoryId: $categoryId';
  }
}
