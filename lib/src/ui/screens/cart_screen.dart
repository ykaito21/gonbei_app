import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/models/cart_model.dart';
import '../../core/providers/cart_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/base_app_bar.dart';
import '../shared/widgets/stream_wrapper.dart';
import '../shared/widgets/unauthenticated_card.dart';
import '../widgets/cart_list.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      //* could be consumer and listen change but changing tab rebuild screen anyway
      body: context.provider<FirebaseUser>(listen: true) == null
          ? UnauthenticatedCard()
          : StreamWrapper<List<CartModel>>(
              stream: context.provider<CartProvider>().streamCart,
              onError: (context, _) => StyleList.errorViewState(
                  context.translate('error'), StyleList.baseSubtitleTextStyle),
              onSuccess: (context, cart) {
                if (cart.isEmpty)
                  return StyleList.emptyViewState(
                      context.translate('emptyCart'),
                      StyleList.baseSubtitleTextStyle);
                return CartList(cart: cart);
              },
            ),
    );
  }
}
