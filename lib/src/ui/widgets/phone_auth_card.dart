import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import '../../core/providers/auth_screen_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/base_button.dart';
import '../shared/widgets/base_flat_button.dart';
import '../shared/platform/platform_complex_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/widgets/base_text_field.dart';

class PhoneAuthCard extends StatelessWidget {
  const PhoneAuthCard({Key key}) : super(key: key);

  Widget _dialogContent(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PinInputTextField(
        keyboardType: TextInputType.phone,
        controller: context.provider<AuthScreenProvider>().otpController,
        autoFocus: true,
        decoration: UnderlineDecoration(
          color: Colors.redAccent,
          enteredColor: Colors.greenAccent,
        ),
      ),
    );
  }

  Future<void> _defaultActionOnPressed(
      BuildContext context, String verificationId) async {
    final authScreenProvider = context.provider<AuthScreenProvider>();
    context.unfocus;
    try {
      await authScreenProvider.submitOTP(verificationId);
      context.provider<AuthScreenProvider>().otpController.clear();
      //* need to find a better way instead of this to pop two screens
      context.pop();
      context.pop();
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: authScreenProvider.authTypeSignUp
            ? context.translate('signUpFailed')
            : context.translate('logInFailed'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  void _cancelActionOnPressed(BuildContext context) {
    context.pop();
    context.provider<AuthScreenProvider>().otpController.clear();
  }

  Future<void> showOTPDialog(
      BuildContext context, String verificationId) async {
    //* case verificationCompleted
    if (verificationId == null) {
      context.pop();
    } else {
      await PlatformComplexAlertDialog(
        title: context.translate('enterCode'),
        content: _dialogContent(context),
        defaultActionWidget: Text(context.translate('send')),
        defaultActionOnPressed: () async {
          await _defaultActionOnPressed(context, verificationId);
        },
        cancelActionWidget: Text(context.translate('cancel')),
        cancelActionOnPressed: () => _cancelActionOnPressed(context),
      ).show(context);
    }
  }

  Future<void> _onSubmittedPhoneNumberAuth(BuildContext context) async {
    context.unfocus;
    final authScreenProvider = context.provider<AuthScreenProvider>();
    context.unfocus;
    try {
      await authScreenProvider.submitPhoneNumberAuth(context, showOTPDialog);
    } catch (e) {
      PlatformExceptionAlertDialog(
              title: authScreenProvider.authTypeSignUp
                  ? context.translate('signUpFailed')
                  : context.translate('logInFailed'),
              exception: e,
              context: context)
          .show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authScreenProvider = context.provider<AuthScreenProvider>();
    return Expanded(
      child: GestureDetector(
        onTap: () => context.unfocus,
        child: Container(
          //* for unfocus
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: StyleList.verticalPadding10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    StreamBuilder<String>(
                      stream: authScreenProvider.streamPhoneNumber,
                      builder: (context, snapshot) {
                        return BaseTextField(
                          labelText: context.translate('phoneNumber'),
                          prefixIcon: Icon(
                            Icons.phone_android,
                            color: context.accentColor,
                          ),
                          errorText:
                              context.translate(snapshot.error.toString()),
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          onChanged: authScreenProvider.changePhoneNumber,
                        );
                      },
                    ),
                    StyleList.verticalBox10,
                    StreamBuilder<bool>(
                      stream: authScreenProvider.streamPhoneNumberValid,
                      builder: (context, snapshot) {
                        return BaseButton(
                          buttonText: authScreenProvider.authTypeSignUp
                              ? context.translate('signUp')
                              : context.translate('logIn'),
                          onPressed: snapshot.hasData
                              ? () => _onSubmittedPhoneNumberAuth(context)
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
              BaseFlatButton(
                buttonText: authScreenProvider.authTypeSignUp
                    ? context.translate('orSignUpWithOtherMethods')
                    : context.translate('orLogInWithOtherMethods'),
                onPressed: authScreenProvider.toggleShowPhoneForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
