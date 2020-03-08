import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../models/user_model.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';

class UserProvider {
  FirebaseUser _currentUser;
  final _dbService = DatabaseService.instance;
  final _userSubject = BehaviorSubject<UserModel>();
  Stream<UserModel> get streamUser => _userSubject.stream;
  UserModel get user => _userSubject.value;

  set currentUser(FirebaseUser value) {
    if (_currentUser != value) {
      _currentUser = value;
      if (_currentUser != null) initUser().listen(_userSubject.add);
    }
  }

  dispose() {
    _userSubject.close();
  }

  Stream<UserModel> initUser() {
    // if (_currentUser != null) {
    final Stream<DocumentSnapshot> res = _dbService.streamDocumentById(
      path: ApiPath.user(userId: _currentUser.uid),
    );
    return res.map(
      (doc) => UserModel.fromFirestore(doc.data, doc.documentID),
    );
    // }
    // return null;
  }
}
