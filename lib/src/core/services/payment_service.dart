import 'package:cloud_functions/cloud_functions.dart';
import 'package:stripe_payment/stripe_payment.dart';
import './secrets.dart';

class PaymentService {
  PaymentService._() {
    //* need to change ios target 11.0 and android 16 to use package
    StripePayment.setOptions(
        StripeOptions(publishableKey: Secrets.publishableKey));
  }
  static final instance = PaymentService._();
  // factory PaymentService() => instance;

  //* for addStripePaymentMehtod onCall function
  Future<bool> addPaymentMethod() async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      final callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'addStripePaymentMehtod',
      );
      final res = await callable.call(<String, dynamic>{
        'paymentMethodId': paymentMethod.id,
      });
      return res.data['result'];
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
