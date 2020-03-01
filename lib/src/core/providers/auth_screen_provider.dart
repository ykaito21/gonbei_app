import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import '../mixins/validation_mixin.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';

import 'base_provider.dart';

class AuthScreenProvider extends BaseProvider with ValidationMixin {
  bool _authTypeSignUp = false;
  bool _showEmailForm = false;
  bool _showPhoneForm = false;

  bool get authTypeSignUp => _authTypeSignUp;
  bool get showEmailForm => _showEmailForm;
  bool get showPhoneForm => _showPhoneForm;

  void toggleAuthType() {
    _authTypeSignUp = !_authTypeSignUp;
    notifyListeners();
  }

  void toggleShowEmailForm() {
    _showEmailForm = !_showEmailForm;
    changeEmail(null);
    changePassword(null);
    notifyListeners();
  }

  void toggleShowPhoneForm() {
    _showPhoneForm = !_showPhoneForm;
    changePhoneNumber(null);
    notifyListeners();
  }

  final _dbService = DatabaseService.instance;
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    // _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailSubject.close();
    _passwordSubject.close();
    _phoneNumberSubject.close();
    _otpController.dispose();
    super.dispose();
  }

// Anonymous Signup
  // Future<void> anonymousSignUp() async {
  //   try {
  //     setViewState(ViewState.Busy);
  //     final newUserAuthResult = await _auth.signInAnonymously();
  //     await _dbService.createDocument(
  //         path: ApiPath.user(userId: newUserAuthResult.user.uid));
  //     setViewState(ViewState.Retrieved);
  //   } catch (e) {
  //     print(e);
  //     setViewState(ViewState.Error);
  //   }
  // }

// convert
  // Future<void> convertFromAnonymous({String email, String password}) async {
  //   // need _user with proxyprovider
  //   if (_user != null && _user.isAnonymous) {
  //     try {
  //       setViewState(ViewState.Busy);
  //       final credential =
  //           EmailAuthProvider.getCredential(email: email, password: password);
  //       await _user.linkWithCredential(credential);
  //       setViewState(ViewState.Retrieved);
  //     } catch (e) {
  //       print(e);
  //       setViewState(ViewState.Error);
  //     }
  //   }
  // }

  // For emailAuthCard
  //* Possible to add email link signin
  // final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  // FocusNode get emailFocusNode => _emailFocusNode;
  FocusNode get passwordFocusNode => _passwordFocusNode;

  final _emailSubject = BehaviorSubject<String>();
  final _passwordSubject = BehaviorSubject<String>();

  Stream<String> get streamEmail =>
      _emailSubject.stream.transform(validateEmail);
  Stream<String> get streamPassword =>
      _passwordSubject.stream.transform(validatePassword);
  Stream<bool> get streamEmailAuthValid => CombineLatestStream.combine2(
      streamEmail, streamPassword, (email, password) => true);

  Function(String) get changeEmail => _emailSubject.add;
  Function(String) get changePassword => _passwordSubject.add;

  Future<void> submitEmailAuth() async {
    setViewState(ViewState.Busy);
    final validEmail = _emailSubject.value;
    final validPassword = _passwordSubject.value;
    try {
      if (_authTypeSignUp) {
        await _signUp(email: validEmail, password: validPassword);
        setViewState(ViewState.Retrieved);
      } else {
        await _logIn(email: validEmail, password: validPassword);
        setViewState(ViewState.Retrieved);
      }
      changeEmail(null);
      changePassword(null);
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }

  // SignUp
  Future<void> _signUp(
      {@required String email, @required String password}) async {
    try {
      final newUserAuthResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _dbService.createDocument(
          path: ApiPath.user(userId: newUserAuthResult.user.uid));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // LogIn
  Future<void> _logIn(
      {@required String email, @required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

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

  Future<void> submitThirdPartyAuth(String selectedAuth) async {
    setViewState(ViewState.Busy);
    try {
      switch (selectedAuth) {
        case 'Google':
          await _signInWithGoogle();
          setViewState(ViewState.Retrieved);
          break;
        case 'Apple':
          await _signInWithApple();
          setViewState(ViewState.Retrieved);
          break;
      }
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }

// SignIn with Google
//* possible to get additional info from user
  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          final credential = GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          final newUserAuthResult =
              await _auth.signInWithCredential(credential);
          await _dbService.createDocument(
              path: ApiPath.user(userId: newUserAuthResult.user.uid));
        } else {
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
  Future<void> _signInWithApple({List<Scope> scopes = const []}) async {
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
          await _dbService.createDocument(
              path: ApiPath.user(userId: newUserAuthResult.user.uid));
          break;
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

  final _phoneNumberSubject = BehaviorSubject<String>();

  Stream<String> get streamPhoneNumber =>
      _phoneNumberSubject.stream.transform(validatePhoneNumber);

  Stream<bool> get streamPhoneNumberValid =>
      streamPhoneNumber.map((phoneNumber) => true);
  Function(String) get changePhoneNumber => _phoneNumberSubject.add;

  Future<void> submitPhoneNumberAuth(
      BuildContext context, Function showOTPDialog) {
    final validPhoneNumber = _phoneNumberSubject.value;
    _signInWithPhoneNumber(
      context: context,
      phoneNumber: validPhoneNumber,
      showOTPDialog: showOTPDialog,
    );
  }

  //SignIn with Phone Number
  //* Phone Authentication requires additional configuration steps
  Future<void> _signInWithPhoneNumber({
    @required BuildContext context,
    @required String phoneNumber,
    @required Function showOTPDialog,
  }) async {
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

  final _otpController = TextEditingController();
  TextEditingController get otpController => _otpController;

  //SignIn with SMS OTP
  Future<void> signInWithOTP({
    @required String verificationId,
  }) async {
    try {
      setViewState(ViewState.Busy);
      final credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: _otpController.text,
      );
      final newUserAuthResult = await _auth.signInWithCredential(credential);
      await _dbService.createDocument(
          path: ApiPath.user(userId: newUserAuthResult.user.uid));
      setViewState(ViewState.Retrieved);
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }
}
