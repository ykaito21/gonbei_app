import 'package:flutter/material.dart';
import '../../core/models/payment_model.dart';
import '../../core/providers/payment_provider.dart';

import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/stream_wrapper.dart';
import 'payment_methods_card.dart';

class PaymentMethodsList extends StatelessWidget {
  const PaymentMethodsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamWrapper<List<PaymentModel>>(
      stream: context.provider<PaymentProvider>().streamSources(),
      onError: (BuildContext context, _) => StyleList.errorViewState(
          context.translate('error'), StyleList.baseSubtitleTextStyle),
      onSuccess: (BuildContext context, List<PaymentModel> methods) {
        if (methods.isEmpty)
          return StyleList.emptyViewState(context.translate('noPaymentMethod'),
              StyleList.baseSubtitleTextStyle);
        return ListView.builder(
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final paymentMethod = methods[index];
            return PaymentMethodsCard(paymentMethod: paymentMethod);
          },
        );
      },
    );
  }
}
