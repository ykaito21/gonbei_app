import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'cart_model.dart';

//* to get time temporary
//? firebase server timestamp
DateTime parseTime(dynamic date) {
  if (date != null) {
    if (Platform.isIOS) {
      return (date as Timestamp).toDate();
    } else {
      return Timestamp(date.seconds, date.nanoseconds).toDate();
    }
  } else {
    return null;
  }
}

class OrderModel extends Equatable {
  final String id;
  final int price;
  final int quantity;
  final String code;
  final DateTime date;
  final String status;
  final List<CartModel> cart;

  OrderModel({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.code,
    @required this.date,
    @required this.status,
    @required this.cart,
  })  : assert(id != null),
        assert(price != null),
        assert(quantity != null),
        assert(code != null),
        assert(quantity != null),
        assert(date != null),
        assert(status != null),
        assert(cart != null);

  factory OrderModel.fromFirestore(Map snapshot, String id) {
    return OrderModel(
      id: id ?? '',
      price: snapshot['price'] ?? 0,
      quantity: snapshot['quantity'] ?? 0,
      code: snapshot['code'] ?? '',
      date: parseTime(snapshot['date']) ?? DateTime.now(),
      status: snapshot['status'] ?? '',
      cart: (snapshot['cart'] as List ?? [])
          .map((data) => CartModel.fromFirestore(data, data['id']))
          .toList(),
    );
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      // "id": id,
      "price": price,
      "quantity": quantity,
      "code": code,
      "date": date,
      "status": status,
      "cart": cart.map((cartItem) => cartItem.toMapForeFirestore()).toList(),
      "createdAt": DateTime.now(),
    };
  }

  @override
  List<Object> get props => [id, price, quantity, code, date, status, cart];

  @override
  bool get stringify => true;
}
