import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/providers/auth_screen_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/widgets/base_button.dart';
import '../shared/widgets/base_flat_button.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/widgets/base_text_field.dart';

class EmailAuthCard extends StatelessWidget {
  const EmailAuthCard({Key key}) : super(key: key);

  Future<void> _onSubmittedEmailAuth(BuildContext context) async {
    final authScreenProvider = context.provider<AuthScreenProvider>();
    // authScreenProvider.emailFocusNode.unfocus();
    // final sucessSnackBarText = authScreenProvider.authTypeSignUp
    //     ? context.translate('signUpSuccess')
    //     : context.translate('logInSuccess');
    context.unfocus;
    try {
      await authScreenProvider.submitEmailAuth();
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
      PlatformExceptionAlertDialog(
        title: authScreenProvider.authTypeSignUp
            ? context.translate('signUpFailed')
            : context.translate('logInFailed'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authScreenProvider = context.provider<AuthScreenProvider>();
    //! buggy when pop button pressed without tap keyboard done, textfield is showing up
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
                      stream: authScreenProvider.streamEmail,
                      builder: (context, snapshot) {
                        return BaseTextField(
                          // focusNode: authScreenProvider.emailFocusNode,
                          labelText: context.translate('email'),
                          prefixIcon: Icon(
                            Icons.email,
                            color: context.accentColor,
                          ),
                          errorText:
                              context.translate(snapshot.error.toString()),
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => context.requestFocus(
                              authScreenProvider.passwordFocusNode),
                          onChanged: authScreenProvider.changeEmail,
                        );
                      },
                    ),
                    StyleList.verticalBox10,
                    //* need to find a better way instead of nesting streamBuilder
                    StreamBuilder<bool>(
                      stream: authScreenProvider.streamEmailAuthValid,
                      builder: (context, snapshotIsValid) {
                        return StreamBuilder<String>(
                          stream: authScreenProvider.streamPassword,
                          builder: (context, snapshot) {
                            return BaseTextField(
                              labelText: context.translate('password'),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: context.accentColor,
                              ),
                              errorText:
                                  context.translate(snapshot.error.toString()),
                              obscureText: true,
                              focusNode: authScreenProvider.passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              onSubmitted: !snapshotIsValid.hasData
                                  ? null
                                  : (_) => _onSubmittedEmailAuth(context),
                              onChanged: authScreenProvider.changePassword,
                            );
                          },
                        );
                      },
                    ),
                    StyleList.verticalBox10,
                    StreamBuilder<bool>(
                      stream: authScreenProvider.streamEmailAuthValid,
                      builder: (context, snapshot) {
                        return BaseButton(
                          buttonText: authScreenProvider.authTypeSignUp
                              ? context.translate('signUp')
                              : context.translate('logIn'),
                          onPressed: !snapshot.hasData
                              ? null
                              : () => _onSubmittedEmailAuth(context),
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
                onPressed: authScreenProvider.toggleShowEmailForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
