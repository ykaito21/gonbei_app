import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider {
  AuthProvider._();
  static final instance = AuthProvider._();
  // factory AuthProvider() => instance;
  final _auth = FirebaseAuth.instance;
  final _authService = AuthService.instance;
  Stream<FirebaseUser> get user => _auth.onAuthStateChanged;

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
