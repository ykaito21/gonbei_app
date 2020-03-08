import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../mixins/validation_mixin.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
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
  final _authService = AuthService.instance;

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

  Future<void> _createNewUser(String userId) async {
    try {
      // maybe need to check userId is not null
      await _dbService.createDocument(path: ApiPath.user(userId: userId));
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // For emailAuthCard
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
        final newUserId = await _authService.signUp(validEmail, validPassword);
        await _createNewUser(newUserId);
        setViewState(ViewState.Retrieved);
      } else {
        await _authService.logIn(validEmail, validPassword);
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

  Future<void> submitThirdPartyAuth(String selectedAuth) async {
    setViewState(ViewState.Busy);
    try {
      switch (selectedAuth) {
        case 'Google':
          final newUserId = await _authService.signInWithGoogle();
          await _createNewUser(newUserId);
          setViewState(ViewState.Retrieved);
          break;
        case 'Apple':
          final newUserId = await _authService.signInWithApple();
          await _createNewUser(newUserId);
          setViewState(ViewState.Retrieved);
          break;
      }
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
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
      BuildContext context, Function showOTPDialog) async {
    final validPhoneNumber = _phoneNumberSubject.value;
    try {
      await _authService.signInWithPhoneNumber(
          context, validPhoneNumber, showOTPDialog);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  final _otpController = TextEditingController();
  TextEditingController get otpController => _otpController;

  Future<void> submitOTP(verificationId) async {
    setViewState(ViewState.Busy);
    try {
      final newUserId =
          await _authService.signInWithOTP(verificationId, _otpController.text);
      await _createNewUser(newUserId);
      setViewState(ViewState.Retrieved);
    } catch (e) {
      print(e);
      setViewState(ViewState.Error);
      rethrow;
    }
  }

  // // Anonymous Signup
  // Future<void> anonymousSignUp() async {
  //   try {
  //     setViewState(ViewState.Busy);
  //     final newUserId = await _authService.signInAnonymously();
  //     await _dbService.createDocument(path: ApiPath.user(userId: newUserId));
  //     setViewState(ViewState.Retrieved);
  //   } catch (e) {
  //     print(e);
  //     setViewState(ViewState.Error);
  //     rethrow;
  //   }
  // }

  // // convert
  // Future<void> convertFromAnonymous(
  //     {@required String email, @required String password}) async {
  //   // need FirebaseUser _user
  //   if (_user != null && _user.isAnonymous) {
  //     try {
  //       setViewState(ViewState.Busy);
  //       _authService.convertAnonymous(_user, email, password);
  //       setViewState(ViewState.Retrieved);
  //     } catch (e) {
  //       print(e);
  //       setViewState(ViewState.Error);
  //     }
  //   }
  // }
}
