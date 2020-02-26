import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  CategoryModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  });

  factory CategoryModel.fromFirestore(Map snapshot, String id) {
    return CategoryModel(
      id: id ?? '',
      name: snapshot['name'] ?? '',
      imageUrl: snapshot['imageUrl'] ?? '',
    );
  }

  @override
  List<Object> get props => [id, name, imageUrl];

  @override
  bool get stringify => true;
}
