import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  UserModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(imageUrl != null);

  factory UserModel.fromFirestore(Map snapshot, String id) {
    return UserModel(
      id: id ?? '',
      name: snapshot['name'] ?? '',
      imageUrl: snapshot['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      // "id": id,
      "name": name,
      "imageUrl": imageUrl,
      //  "createdAt": DateTime.now(),
    };
  }

  @override
  List<Object> get props => [id, name, imageUrl];

  @override
  bool get stringify => true;
}
