import 'package:flutter/material.dart';
import '../../core/models/cart_model.dart';
import '../../core/providers/cart_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';

class ColumnQuantityCounter extends StatelessWidget {
  final CartModel cartItem;
  const ColumnQuantityCounter({
    Key key,
    @required this.cartItem,
  })  : assert(cartItem != null),
        super(key: key);

  Future<void> _updateQuantity(
    BuildContext context,
    CartModel cartItem,
    bool isIncrement,
  ) async {
    final cartProvider = context.provider<CartProvider>();
    try {
      if (isIncrement) {
        await cartProvider.updateCartItem(
            cartItem: cartItem, isIncrement: true);
      } else {
        if (cartItem.quantity <= 1) {
          await cartProvider.removeCartItem(cartItem);
          //* optional
          // Scaffold.of(context)
          //   ..removeCurrentSnackBar()
          //   ..showSnackBar(
          //     context.baseSnackBar(
          //       context.localizeMessage(cartItem.productItem.name, 'isRemoved'),
          //     ),
          //   );
        } else {
          await cartProvider.updateCartItem(
              cartItem: cartItem, isIncrement: false);
        }
      }
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: context.translate('error'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonTheme(
          minWidth: 20.0,
          child: FlatButton(
            padding: StyleList.removePadding,
            onPressed: () => _updateQuantity(context, cartItem, true),
            child: Icon(
              Icons.add,
              color: context.primaryColor,
            ),
            color: context.accentColor,
            shape: CircleBorder(
              side: BorderSide(
                color: context.accentColor,
              ),
            ),
          ),
        ),
        Text(
          '${cartItem.quantity}',
          style: StyleList.smallBoldTextStyle,
        ),
        ButtonTheme(
          minWidth: 20.0,
          child: FlatButton(
            padding: StyleList.removePadding,
            onPressed: () => _updateQuantity(context, cartItem, false),
            child: Icon(
              Icons.remove,
              color: context.accentColor,
            ),
            color: context.primaryColor,
            shape: CircleBorder(
              side: BorderSide(
                color: context.accentColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
