import 'dart:async';

class ValidationMixin {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      if (value != null) {
        final email = value.replaceAll(" ", "");
        if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
          sink.add(email);
        } else {
          sink.addError('emailValidationError');
        }
      }
    },
  );
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      if (value != null) {
        final password = value.replaceAll(" ", "");
        if (password.length >= 6) {
          sink.add(password);
        } else {
          sink.addError('passwordValidationError');
        }
      }
    },
  );
  final validatePhoneNumber = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      if (value != null) {
        final phone = value.replaceAll(" ", "");
        if (RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)").hasMatch(phone)) {
          sink.add(phone);
        } else {
          sink.addError('phoneNumberValidationError');
        }
      }
    },
  );
}
