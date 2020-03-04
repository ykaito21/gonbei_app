import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();
  final _db = Firestore.instance;
  // factory DatabaseService() => instance;

// CREATE
  Future<void> createDocument({
    @required String path,
  }) async {
    try {
      await _db.document(path).setData({});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<DocumentReference> addDocument({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    try {
      return await _db.collection(path).add(data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// READ
  // Future<QuerySnapshot> getDataCollection({
  //   @required String path,
  //   String orderBy = '',
  //   bool descending = false,
  // }) async {
  //   try {
  //     if (orderBy.isEmpty) return await _db.collection(path).getDocuments();
  //     return await _db
  //         .collection(path)
  //         .orderBy(orderBy, descending: descending)
  //         .getDocuments();
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  Stream<QuerySnapshot> streamDataCollection({
    @required String path,
    String orderBy = '',
    bool descending = false,
  }) {
    if (orderBy.isEmpty) return _db.collection(path).snapshots();
    return _db
        .collection(path)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  Future<DocumentSnapshot> getDocumentById({
    @required String path,
  }) async {
    try {
      return await _db.document(path).get();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<DocumentSnapshot> streamDocumentById({
    @required String path,
  }) {
    return _db.document(path).snapshots();
  }

// specific read
  Future<QuerySnapshot> getSelectedDataCollection({
    @required String path,
    @required String referenceTag,
    @required String referenceId,
    String orderBy = '',
    bool descending = false,
  }) async {
    try {
      if (orderBy.isEmpty)
        return await _db
            .collection(path)
            .where(referenceTag, isEqualTo: referenceId)
            .getDocuments();
      return _db
          .collection(path)
          .where(referenceTag, isEqualTo: referenceId)
          .orderBy(orderBy, descending: descending)
          .getDocuments();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// UPDATE
  Future<void> updateDocument({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    try {
      await _db.document(path).updateData(data);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

// DELETE
  Future<void> removeDocument({
    @required String path,
  }) async {
    try {
      _db.document(path).delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> removeAllDocument({
    @required List<String> pathList,
  }) async {
    try {
      await _db.runTransaction((Transaction tx) async {
        for (String path in pathList) await tx.delete(_db.document(path));
      });
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
