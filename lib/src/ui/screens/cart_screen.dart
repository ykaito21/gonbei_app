import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gonbei_app/src/core/models/cart_model.dart';
import 'package:gonbei_app/src/ui/global/style_list.dart';
import 'package:gonbei_app/src/ui/shared/widgets/stream_wrapper.dart';
import 'package:gonbei_app/src/ui/widgets/cart_card.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:omusubi_app/src/core/providers/base_provider.dart';
import 'package:provider/provider.dart';

// import '../../core/models/order_item.dart';
// import '../../core/models/cart_item.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
// import '../../core/providers/payment_provider.dart';
import '../global/routes/route_path.dart';
import '../global/extensions.dart';

import '../shared/widgets/base_app_bar.dart';
import '../shared/widgets/base_button.dart';
// import '../shared/widgets/snack_bars.dart';
// import '../shared/widgets/view_state_widget.dart';
import '../shared/platform/platform_alert_dialog.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
// import '../widgets/cart_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  Future<void> _onDismissedCartItem(
    BuildContext context,
    CartProvider cartProvider,
    CartModel cartItem,
  ) async {
    try {
      await cartProvider.removeCartItem(cartItem);
      //* optional
      // Scaffold.of(context)
      //   ..removeCurrentSnackBar()
      //   ..showSnackBar(
      //     context.baseSnackBar(
      //       context.localizeMessage(cartItem.productItem.name, 'isRemoved'),
      //     ),
      //   );
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: context.translate('error'),
        exception: e,
        context: context,
      ).show(context);
    }
  }

  // Future<void> _orderCart({
  //   @required BuildContext context,
  //   @required CartProvider cartProvider,
  //   @required int totalPrice,
  //   @required int totalQuantity,
  //   @required List<CartItem> cart,
  // }) async {
  //   //todo handle card
  //   try {
  //     Scaffold.of(context)
  //       ..removeCurrentSnackBar()
  //       ..showSnackBar(
  //         SnackBars.baseSnackBar(context, '注文しました。'),
  //       );
  //     await cartProvider.convertToOrder(
  //       OrderItem(
  //         id: 'New',
  //         price: totalPrice,
  //         quantity: totalQuantity,
  //         date: DateTime.now(),
  //         status: 'requires_confirmation',
  //         cart: cart,
  //       ),
  //     );
  //   } catch (e) {
  //     PlatformExceptionAlertDialog(
  //       title: 'エラー',
  //       exception: e,
  //     ).show(context);
  //   }

  //   //* Square Payment Test
  //   // cartProvider.paymentStart();
  // }

  // // stripe card check
  // Future<void> _addCard(
  //     {BuildContext context, PaymentProvider paymentProvider}) async {
  //   try {
  //     //TODO maybe add progress indicator until get result
  //     final bool result = await paymentProvider.addCardToStripe();
  //     PlatformAlertDialog(
  //       title: result ? '登録完了' : '登録失敗',
  //       content: result ? 'カードを登録しました' : 'カードを登録できませんでした',
  //       defaultActionText: 'OK',
  //     ).show(context);
  //   } catch (e) {
  //     if (e.code != 'cancelled') {
  //       PlatformExceptionAlertDialog(
  //         title: 'エラー',
  //         exception: e,
  //       ).show(context);
  //     }
  //   }
  // }

  // Future<bool> _checkCard(
  //     {BuildContext context, PaymentProvider paymentProvider}) async {
  //   bool confirmPaymentMethod = false;
  //   try {
  //     confirmPaymentMethod = await paymentProvider.checkPaymentMethod();
  //   } catch (e) {
  //     PlatformExceptionAlertDialog(
  //       title: 'エラー',
  //       exception: e,
  //     ).show(context);
  //   }
  //   return confirmPaymentMethod;
  // }

  Future<bool> _confirmDismiss(BuildContext context, String productName) async {
    return await PlatformAlertDialog(
      title: context.localizeAlertTtile(productName, 'alertDeleteTitle'),
      content: context.translate('alertDeleteContentCartItem'),
      defaultActionText: context.translate('delete'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.provider<CartProvider>();
    final currentUser = context.provider<FirebaseUser>();
    return Scaffold(
      appBar: BaseAppBar(),
      body: currentUser == null
          ? Container(
              width: double.infinity,
              padding: StyleList.allPadding10,
              child: BaseButton(
                buttonText: context.translate('signupOrLogin'),
                onPressed: () => context.pushNamed(RoutePath.authScreen,
                    rootNavigator: true),
              ),
            )
          : StreamWrapper<List<CartModel>>(
              stream: cartProvider.streamCart,
              onError: (BuildContext context, _) => StyleList.errorViewState(
                  context.translate('error'), StyleList.baseSubtitleTextStyle),
              onSuccess: (BuildContext context, List<CartModel> cart) {
                final totalPrice = cartProvider.totalPrice();
                // final totalQuantity = cartProvider.totalQuantity();
                if (cart.isEmpty)
                  return StyleList.emptyViewState(
                      context.translate('emptyCart'),
                      StyleList.baseSubtitleTextStyle);
                return ModalProgressHUD(
                  // inAsyncCall:
                  //     Provider.of<PaymentProvider>(context).viewState ==
                  //         ViewState.Busy,
                  inAsyncCall: false,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final cartItem = cart[index];
                              return Dismissible(
                                key: ValueKey(cartItem),
                                direction: DismissDirection.endToStart,
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return await _confirmDismiss(
                                      context, cartItem.productItem.name);
                                },
                                onDismissed: (direction) =>
                                    _onDismissedCartItem(
                                  context,
                                  cartProvider,
                                  cartItem,
                                ),
                                background: Container(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  alignment: Alignment.centerRight,
                                  color: context.accentColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.delete,
                                        color: context.primaryColor,
                                        size: 40,
                                      ),
                                      Text(
                                        context.translate('delete'),
                                        style: StyleList.smallBoldTextStyle
                                            .copyWith(
                                          color: context.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: StyleList.horizontalPadding20,
                                  child: CartCard(cartItem: cartItem),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: StyleList.allPadding10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: StyleList.horizontalPadding10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    context.translate('total'),
                                    style: StyleList.baseTitleTextStyle,
                                  ),
                                  Text(
                                    context.localizePrice(totalPrice),
                                    style:
                                        StyleList.baseTitleTextStyle.copyWith(
                                      color: context.accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StyleList.verticalBox10,
                            BaseButton(
                              buttonText: context.translate('buy'),
                              onPressed: () async {
                                // final bool confirmCard = await _checkCard(
                                //     context: context,
                                //     paymentProvider: _paymentProvider);
                                // if (confirmCard) {
                                //   await _orderCart(
                                //     context: context,
                                //     cartProvider: _cartProvider,
                                //     totalPrice: _totalPrice,
                                //     totalQuantity: _totalQuantity,
                                //     cart: _cart,
                                //   );
                                // } else {
                                //   await _addCard(
                                //       context: context,
                                //       paymentProvider: _paymentProvider);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
