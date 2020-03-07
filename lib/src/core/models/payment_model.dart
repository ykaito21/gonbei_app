import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PaymentModel extends Equatable {
  final String id;
  final String brand;
  final String lastFour;

  PaymentModel({
    @required this.id,
    @required this.brand,
    @required this.lastFour,
  })  : assert(id != null),
        assert(brand != null),
        assert(lastFour != null);

  factory PaymentModel.fromFirestore(Map snapshot, String id) {
    return PaymentModel(
        id: id ?? '',
        brand: snapshot['card']['brand'] ?? '',
        lastFour: snapshot['card']['last4'] ?? '');
  }

  @override
  List<Object> get props => [id, brand, lastFour];

  @override
  bool get stringify => true;
}
