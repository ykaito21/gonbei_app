import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/models/payment_model.dart';
import '../global/extensions.dart';

class PaymentMethodsCard extends StatelessWidget {
  final PaymentModel paymentMethod;
  const PaymentMethodsCard({
    Key key,
    this.paymentMethod,
  })  : assert(paymentMethod != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO maybe need to support multiple cards and delete card
    return ListTile(
      leading: _cardIcon(paymentMethod.brand, context),
      title: Text(paymentMethod.brand),
      trailing: Text(paymentMethod.lastFour),
    );
  }

  Widget _cardIcon(String brand, BuildContext context) {
    switch (brand) {
      case 'visa':
        return Icon(
          FontAwesomeIcons.ccVisa,
          color: context.accentColor,
        );
      case 'mastercard':
        return Icon(
          FontAwesomeIcons.ccMastercard,
          color: context.accentColor,
        );
      case 'jcb':
        return Icon(
          FontAwesomeIcons.ccJcb,
          color: context.accentColor,
        );
      case 'amex':
        return Icon(
          FontAwesomeIcons.ccAmex,
          color: context.accentColor,
        );
      case 'discover':
        return Icon(
          FontAwesomeIcons.ccDiscover,
          color: context.accentColor,
        );
      case 'diners':
        return Icon(
          FontAwesomeIcons.ccDinersClub,
          color: context.accentColor,
        );
      case 'unknown':
        return Icon(
          FontAwesomeIcons.creditCard,
          color: context.accentColor,
        );

      default:
        return Icon(
          FontAwesomeIcons.creditCard,
          color: context.accentColor,
        );
    }
  }
}
