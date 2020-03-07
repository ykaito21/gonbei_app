import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ProductModel extends Equatable {
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
  })  : assert(id != null),
        assert(name != null),
        assert(description != null),
        assert(imageUrl != null),
        assert(price != null),
        assert(categoryId != null);

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

  // Map<String, dynamic> toMapForFirestore() {
  //   return {
  //     // "id": id,
  //     "productId": id,
  //     "name": name,
  //     "description": description,
  //     "imageUrl": imageUrl,
  //     "price": price,
  //     "categoryId": categoryId,
  //   };
  // }

  @override
  List<Object> get props =>
      [id, name, description, imageUrl, price, categoryId];

  @override
  bool get stringify => true;
}
