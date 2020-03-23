import 'package:flutter/material.dart';
import '../../core/models/order_model.dart';
import '../../core/providers/order_history_screen_provider.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/stream_wrapper.dart';
import 'order_history_card.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamWrapper<List<OrderModel>>(
      stream: context.provider<OrderHistoryScreenProvider>().streamOrders(),
      onError: (context, _) => StyleList.errorViewState(
          context.translate('error'), StyleList.baseSubtitleTextStyle),
      onSuccess: (context, orders) {
        if (orders.isEmpty)
          return StyleList.emptyViewState(
              context.translate('noOrder'), StyleList.baseSubtitleTextStyle);
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final orderItem = orders[index];
            return OrderRecordCard(orderItem: orderItem);
          },
        );
      },
    );
  }
}
