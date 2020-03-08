import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';

class OrderHistoryScreenProvider {
  FirebaseUser _currentUser;
  final _dbService = DatabaseService.instance;

  set currentUser(FirebaseUser value) {
    if (_currentUser != value) {
      _currentUser = value;
    }
  }

  Stream<List<OrderModel>> streamOrders() {
    if (_currentUser != null) {
      final Stream<QuerySnapshot> res = _dbService.streamDataCollection(
        path: ApiPath.orders(userId: _currentUser.uid),
        orderBy: 'createdAt',
        descending: true,
      );
      return res.map(
        (list) {
          final List<OrderModel> orders = list.documents
              .map(
                (doc) => OrderModel.fromFirestore(doc.data, doc.documentID),
              )
              .toList();

          return orders;
        },
      );
    }
    return null;
  }

  Future<void> updateOrderItem(OrderModel orderItem) async {
    try {
      await _dbService.updateDocument(
        path: ApiPath.orderItem(
            userId: _currentUser.uid, orderItemId: orderItem.id),
        data: {
          "status": "REFUND_REQUESTED",
        },
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
