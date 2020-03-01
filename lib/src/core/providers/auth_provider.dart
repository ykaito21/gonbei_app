import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;
}
