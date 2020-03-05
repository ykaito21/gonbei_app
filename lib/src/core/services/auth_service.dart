import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  // factory AuthService() => instance;

  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  // SignOut
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // SignUp
  //* Possible to add email link signin
  Future<String> signUp(String email, String password) async {
    try {
      final newUserAuthResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return newUserAuthResult.user.uid;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // LogIn
  Future<void> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // SignIn with Google
//* possible to get additional info from user
  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          final credential = GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          final newUserAuthResult =
              await _auth.signInWithCredential(credential);
          return newUserAuthResult.user.uid;
        } else {
          print('exception');
          throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token',
          );
        }
      } else {
        print('exception');
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // SignIn with Apple
  //* possible to get additional info from user with scopes
  Future<String> signInWithApple({List<Scope> scopes = const []}) async {
    try {
      final isAvailable = await AppleSignIn.isAvailable();
      if (!isAvailable)
        throw PlatformException(
          code: 'ERROR_NOT_AVAILABLE',
          message: 'The operation cannot perform with your device',
        );
      final result = await AppleSignIn.performRequests(
          [AppleIdRequest(requestedScopes: scopes)]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider(providerId: 'apple.com');
          final credential = oAuthProvider.getCredential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          final newUserAuthResult =
              await _auth.signInWithCredential(credential);
          return newUserAuthResult.user.uid;
        case AuthorizationStatus.error:
          print(result.error.toString());
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );
          break;
        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
          break;
      }
      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //SignIn with Phone Number
  //* Phone Authentication requires additional configuration steps
  Future<void> signInWithPhoneNumber(
      BuildContext context, String phoneNumber, Function showOTPDialog) async {
    try {
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential credential) async {
        final AuthResult newUserAuthResult =
            await _auth.signInWithCredential(credential);
        print(newUserAuthResult.user.phoneNumber);
        //* temp solution
        showOTPDialog(context, null);
      };
      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        print(authException.message);
        throw PlatformException(
          code: 'ERROR_VERIFICATION_FAILED',
          message: authException.message,
        );
      };
      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        showOTPDialog(context, verificationId);
      };
      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        showOTPDialog(context, verificationId);
      };
      await _auth.verifyPhoneNumber(
          //* need country code
          phoneNumber: '+81$phoneNumber',
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //SignIn with SMS OTP
  Future<String> signInWithOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final newUserAuthResult = await _auth.signInWithCredential(credential);
      return newUserAuthResult.user.uid;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Future<String> signInAnonymously() async {
  //   try {
  //     final newUserAuthResult = await _auth.signInAnonymously();
  //     return newUserAuthResult.user.uid;
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // Future<void> convertAnonymous(
  //     FirebaseUser user, String email, String password) async {
  //   try {
  //     final credential =
  //         EmailAuthProvider.getCredential(email: email, password: password);
  //     await user.linkWithCredential(credential);
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }
}
