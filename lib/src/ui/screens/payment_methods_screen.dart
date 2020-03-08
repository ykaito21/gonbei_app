import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../core/providers/payment_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/base_button.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../widgets/payment_methods_list.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key key}) : super(key: key);

  Future<void> _addCard(BuildContext context) async {
    try {
      final bool result =
          await context.provider<PaymentProvider>().addCardToStripe();
      PlatformAlertDialog(
        title:
            result ? context.translate('success') : context.translate('failed'),
        content: result
            ? context.translate('addingCardSuccess')
            : context.translate('addingCardFailed'),
        defaultActionText: 'OK',
      ).show(context);
    } catch (e) {
      if (e.code != 'cancelled')
        PlatformExceptionAlertDialog(
          title: context.translate('error'),
          exception: e,
          context: context,
        ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('paymentMethods'),
          style: StyleList.baseSubtitleTextStyle,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: context.provider<PaymentProvider>(listen: true).isBusy,
        child: Padding(
          padding: StyleList.allPadding10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: PaymentMethodsList(),
              ),
              BaseButton(
                buttonText: context.translate('addCard'),
                onPressed: () => _addCard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
