import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/cart_model.dart';
import '../../core/models/order_model.dart';
import '../../core/providers/order_history_screen_provider.dart';
import '../global/extensions.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../shared/platform/platform_alert_dialog.dart';

class OrderRecordCard extends StatelessWidget {
  final OrderModel orderItem;
  const OrderRecordCard({
    Key key,
    @required this.orderItem,
  })  : assert(orderItem != null),
        super(key: key);

  Future<void> _onTapCancel(BuildContext context) async {
    final bool confirmation = await PlatformAlertDialog(
      title: context.localizeAlertTtile(orderItem.code, 'cancel'),
      content: context.translate('alertCancelContentOrder'),
      defaultActionText: context.translate('yes'),
      cancelActionText: context.translate('cancel'),
    ).show(context);
    if (confirmation) {
      try {
        await context
            .provider<OrderHistoryScreenProvider>()
            .updateOrderItem(orderItem);
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: context.translate('error'),
          exception: e,
          context: context,
        ).show(context);
      }
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          context.baseSnackBar(
            context.localizeMessage(orderItem.code, 'isCanceled'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${DateFormat.yMMMMd(context.lang).format(orderItem.date)}',
            ),
            Text(orderItem.code),
          ],
        ),
        children: <Widget>[
          _orderDetailTile(
              leadingText: context.translate('orderCode'),
              titleText: '${orderItem.code}'),
          _orderDetailTile(
            leadingText: context.translate('status'),
            titleText: context.translate(orderItem.status) ??
                context.translate('PROCESSING'),
            onTap: orderItem.status == 'PENDING'
                ? () async {
                    await _onTapCancel(context);
                  }
                : null,
            trailing: Icon(
              Icons.remove_shopping_cart,
              color:
                  orderItem.status == 'REFUNDED' ? context.accentColor : null,
            ),
          ),
          _orderDetailTile(
              leadingText: context.translate('orderTotal'),
              titleText: context.localizePrice(orderItem.price)),
          _orderDetailTile(
              leadingText: context.translate('quantity'),
              titleText: '${orderItem.quantity}'),
          _orderItemListDetailTile(
              context.translate('orderDetails'), orderItem.cart),
        ],
      ),
    );
  }

  Widget _orderDetailTile({
    @required String leadingText,
    @required @required String titleText,
    Function onTap,
    Icon trailing,
  }) {
    return ListTile(
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leadingText,
          ),
          Text(
            titleText,
          ),
        ],
      ),
      trailing: trailing,
    );
  }

  Widget _orderItemListDetailTile(String leadingText, List<CartModel> cart) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            leadingText,
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ...cart.map(
                  (cartItem) {
                    return Row(
                      children: <Widget>[
                        Text(cartItem.productItem.name),
                        SizedBox(width: 20.0),
                        Text('${cartItem.quantity}'),
                      ],
                    );
                  },
                ).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
