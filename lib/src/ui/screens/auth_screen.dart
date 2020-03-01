import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_screen_provider.dart';
import '../../core/providers/base_provider.dart';

import '../shared/widgets/auth_button.dart';
import '../shared/widgets/base_flat_button.dart';
import '../widgets/email_auth_card.dart';
import '../widgets/phone_auth_card.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);

  Future<void> _onPressedAuth(BuildContext context, String selectedAuth) async {
    final authScreenProvider = context.provider<AuthScreenProvider>();
    // final sucessSnackBarText = authScreenProvider.authTypeSignUp
    //     ? context.translate('signUpSuccess')
    //     : context.translate('logInSuccess');
    try {
      await authScreenProvider.submitThirdPartyAuth(selectedAuth);
      //* Optional
      //* if use snackbar, need to wrap widght by builder
      // Scaffold.of(context)
      //   ..removeCurrentSnackBar()
      //   ..showSnackBar(
      //     context.baseSnackBar(sucessSnackBarText),
      //   );
      // Future.delayed(Duration(milliseconds: 1000), () => context.pop());
      context.pop();
    } catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER' &&
          // e.code != 'sign_in_canceled' &&
          e.code != 'ERROR_AUTHORIZATION_DENIED') {
        PlatformExceptionAlertDialog(
          title: authScreenProvider.authTypeSignUp
              ? context.translate('signUpFailed')
              : context.translate('logInFailed'),
          exception: e,
          context: context,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthScreenProvider>(
      create: (context) => AuthScreenProvider(),
      child: Consumer<AuthScreenProvider>(
        builder: (context, authScreenProvider, child) {
          final authTypeSignUp = authScreenProvider.authTypeSignUp;
          final showEmailForm = authScreenProvider.showEmailForm;
          final showPhoneForm = authScreenProvider.showPhoneForm;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                authTypeSignUp
                    ? context.translate('signUp')
                    : context.translate('logIn'),
                style: StyleList.baseSubtitleTextStyle,
              ),
            ),
            body: ModalProgressHUD(
              inAsyncCall: authScreenProvider.viewState == ViewState.Busy,
              child: Padding(
                padding: StyleList.horizontalPadding10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Visibility(
                      visible: !showEmailForm && !showPhoneForm,
                      child: Column(
                        children: <Widget>[
                          AuthButton(
                            onPressed: () => _onPressedAuth(context, 'Google'),
                            buttonText: authTypeSignUp
                                ? context.translate('signUpWithGoogle')
                                : context.translate('logInWithGoogle'),
                            buttonIcon: Icon(
                              FontAwesomeIcons.google,
                              color: context.primaryColor,
                            ),
                          ),
                          if (Platform.isIOS)
                            AuthButton(
                              onPressed: () => _onPressedAuth(context, 'Apple'),
                              buttonText: authTypeSignUp
                                  ? context.translate('signUpWithApple')
                                  : context.translate('logInWithApple'),
                              buttonIcon: Icon(
                                FontAwesomeIcons.apple,
                                color: context.primaryColor,
                              ),
                            ),
                          AuthButton(
                            onPressed: authScreenProvider.toggleShowEmailForm,
                            buttonText: authTypeSignUp
                                ? context.translate('signUpWithEmail')
                                : context.translate('logInWithEmail'),
                            buttonIcon: Icon(
                              FontAwesomeIcons.envelope,
                              color: context.primaryColor,
                            ),
                          ),
                          AuthButton(
                            onPressed: authScreenProvider.toggleShowPhoneForm,
                            buttonText: authTypeSignUp
                                ? context.translate('signUpWithPhoneNumber')
                                : context.translate('logInWithPhoneNumber'),
                            buttonIcon: Icon(
                              FontAwesomeIcons.mobileAlt,
                              color: context.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: showEmailForm && !showPhoneForm,
                      child: EmailAuthCard(),
                    ),
                    //TODO Phone Authentication requires additional configuration steps
                    Visibility(
                      visible: showPhoneForm,
                      child: PhoneAuthCard(),
                    ),
                    Visibility(
                      visible: !showEmailForm && !showPhoneForm,
                      child: BaseFlatButton(
                        buttonText: authTypeSignUp
                            ? context.translate('orLogIn')
                            : context.translate('orSignUp'),
                        onPressed: authScreenProvider.toggleAuthType,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
