import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'platform_alert_dialog.dart';
import '../../global/extensions.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
    @required BuildContext context,
  }) : super(
          title: title,
          content: _message(exception, context),
          defaultActionText: 'OK',
        );
  //* possible to improve
  static String _message(PlatformException exception, BuildContext context) {
    if (exception.message == 'FIRFirestoreErrorDomain' ||
        exception.message ==
            'PERMISSION_DENIED: Missing or insufficient permissions.') {
      if (exception.code == 'Error 7' ||
          exception.code == 'Error performing get') {
        return context.translate('ERROR_OPERATION_NOT_ALLOWED');
      }
    }
    return context.translate(_errors[exception.code]) ??
        context.translate('ERROR_DISABLED');
    // exception.message ??
    // exception.toString();
  }

  static Map<String, String> _errors = {
    // signInAnonymously
    'ERROR_OPERATION_NOT_ALLOWED': 'ERROR_OPERATION_NOT_ALLOWED',
    // createUserWithEmailAndPassword
    'ERROR_WEAK_PASSWORD': 'ERROR_WEAK_PASSWORD',
    'ERROR_INVALID_EMAIL': 'ERROR_INVALID_EMAIL',
    'ERROR_EMAIL_ALREADY_IN_USE': 'ERROR_EMAIL_ALREADY_IN_USE',
    // fetchSignInMethodsForEmail
    'ERROR_INVALID_CREDENTIAL': 'ERROR_INVALID_CREDENTIAL',
    // sendPasswordResetEmail
    'ERROR_USER_NOT_FOUND': 'ERROR_USER_NOT_FOUND',
    // signInWithEmailAndLink
    'ERROR_NOT_ALLOWED': 'ERROR_OPERATION_NOT_ALLOWED',
    'ERROR_DISABLED': 'ERROR_DISABLED',
    'ERROR_INVALID': 'ERROR_DISABLED',
    // signInWithEmailAndPassword
    'ERROR_WRONG_PASSWORD': 'ERROR_WRONG_PASSWORD',
    'ERROR_USER_DISABLED': 'ERROR_USER_DISABLED',
    'ERROR_TOO_MANY_REQUESTS': 'ERROR_DISABLED',
    // signInWithCredential
    'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL': 'ERROR_DISABLED',
    'ERROR_INVALID_ACTION_CODE': 'ERROR_DISABLED',
    // signInWithCustomToken
    'ERROR_INVALID_CUSTOM_TOKEN': 'ERROR_INVALID_CUSTOM_TOKEN',
    'ERROR_CUSTOM_TOKEN_MISMATCH': 'ERROR_INVALID_CUSTOM_TOKEN',
    // confirmPasswordReset
    'EXPIRED_ACTION_CODE': 'ERROR_INVALID_CUSTOM_TOKEN',
    'INVALID_ACTION_CODE': 'ERROR_INVALID_CUSTOM_TOKEN',
    'USER_DISABLED': 'ERROR_USER_DISABLED',
    'USER_NOT_FOUND': 'ERROR_USER_NOT_FOUND',
    'WEAK_PASSWORD': 'ERROR_WEAK_PASSWORD',

    // original
    'ERROR_MISSING_GOOGLE_AUTH_TOKEN': 'ERROR_DISABLED',
    'ERROR_ABORTED_BY_USER': 'ERROR_DISABLED',
    'ERROR_AUTHORIZATION_DENIED': 'ERROR_DISABLED',
    'ERROR_NOT_AVAILABLE': 'ERROR_NOT_AVAILABLE',
    'ERROR_AUTHORIZATION_DENIED': 'ERROR_DISABLED',
    'ERROR_VERIFICATION_FAILED': 'ERROR_DISABLED',

    // other possible exception
    'ERROR_REQUIRES_RECENT_LOGIN': 'ERROR_DISABLED',
    'ERROR_PROVIDER_ALREADY_LINKED': 'ERROR_DISABLED',
    'ERROR_NO_SUCH_PROVIDER': 'ERROR_DISABLED',
    'ERROR_INVALID_USER_TOKEN': 'ERROR_DISABLED',
    'ERROR_NETWORK_REQUEST_FAILED': 'ERROR_DISABLED',
    'ERROR_KEYCHAIN_ERROR': 'ERROR_DISABLED',
    'ERROR_MISSING_CLIENT_IDENTIFIER': 'ERROR_DISABLED',
    'ERROR_USER_TOKEN_EXPIRED': 'ERROR_DISABLED',
    'ERROR_INVALID_API_KEY': 'ERROR_DISABLED',
    'ERROR_CREDENTIAL_ALREADY_IN_USE': 'ERROR_DISABLED',
    'ERROR_INTERNAL_ERROR': 'ERROR_DISABLED',
    'ERROR_USER_MISMATCH': 'ERROR_DISABLED',
    'ERROR_APP_NOT_AUTHORIZED': 'ERROR_DISABLED',
    'ERROR_EXPIRED_ACTION_CODE': 'ERROR_DISABLED',
    'ERROR_INVALID_MESSAGE_PAYLOAD': 'ERROR_DISABLED',
    'ERROR_INVALID_SENDER': 'ERROR_DISABLED',
    'ERROR_INVALID_RECIPIENT_EMAIL': 'ERROR_DISABLED',
    'ERROR_MISSING_IOS_BUNDLE_ID': 'ERROR_DISABLED',
    'ERROR_MISSING_ANDROID_PKG_NAME': 'ERROR_DISABLED',
    'ERROR_UNAUTHORIZED_DOMAIN': 'ERROR_DISABLED',
    'ERROR_INVALID_CONTINUE_URI': 'ERROR_DISABLED',
    'ERROR_MISSING_CONTINUE_URI': 'ERROR_DISABLED',
    'ERROR_MISSING_EMAIL': 'ERROR_DISABLED',
    'ERROR_MISSING_PHONE_NUMBER': 'ERROR_DISABLED',
    'ERROR_INVALID_PHONE_NUMBER': 'ERROR_DISABLED',
    'ERROR_MISSING_VERIFICATION_CODE': 'ERROR_DISABLED',
    'ERROR_INVALID_VERIFICATION_CODE': 'ERROR_DISABLED',
    'ERROR_MISSING_VERIFICATION_ID': 'ERROR_DISABLED',
    'ERROR_INVALID_VERIFICATION_ID': 'ERROR_DISABLED',
    'ERROR_SESSION_EXPIRED': 'ERROR_DISABLED',
    'MISSING_APP_CREDENTIAL': 'ERROR_DISABLED',
    'INVALID_APP_CREDENTIAL': 'ERROR_DISABLED',
    'ERROR_QUOTA_EXCEEDED': 'ERROR_DISABLED',
    'ERROR_MISSING_APP_TOKEN': 'ERROR_DISABLED',
    'ERROR_NOTIFICATION_NOT_FORWARDED': 'ERROR_DISABLED',
    'ERROR_APP_NOT_VERIFIED': 'ERROR_DISABLED',
    'ERROR_CAPTCHA_CHECK_FAILED': 'ERROR_DISABLED',
    'ERROR_WEB_CONTEXT_ALREADY_PRESENTED': 'ERROR_DISABLED',
    'ERROR_WEB_CONTEXT_CANCELLED': 'ERROR_DISABLED',
    'ERROR_INVALID_CLIENT_ID': 'ERROR_DISABLED',
    'ERROR_APP_VERIFICATION_FAILED': 'ERROR_DISABLED',
    'ERROR_WEB_NETWORK_REQUEST_FAILED': 'ERROR_DISABLED',
    'ERROR_NULL_USER': 'ERROR_DISABLED',
    'ERROR_INVALID_PROVIDER_ID': 'ERROR_DISABLED',
    'ERROR_INVALID_DYNAMIC_LINK_DOMAIN': 'ERROR_DISABLED',
    'ERROR_WEB_INTERNAL_ERROR': 'ERROR_DISABLED',
    'ERROR_WEB_USER_INTERACTION_FAILURE': 'ERROR_DISABLED',
    'ERROR_MALFORMED_JWT': 'ERROR_DISABLED',
    'ERROR_LOCAL_PLAYER_NOT_AUTHENTICATED': 'ERROR_DISABLED',
    'ERROR_GAME_KIT_NOT_LINKED': 'ERROR_DISABLED',
    'ERROR_DYNAMIC_LINK_NOT_ACTIVATED': 'ERROR_DISABLED',
    'ERROR_REJECTED_CREDENTIAL': 'ERROR_DISABLED',
  };
}
