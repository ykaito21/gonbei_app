import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/order_history_screen_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../widgets/order_history_list.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate('orderHistory'),
          style: StyleList.baseSubtitleTextStyle,
        ),
      ),
      body: ProxyProvider<FirebaseUser, OrderHistoryScreenProvider>(
        create: (_) => OrderHistoryScreenProvider(),
        update: (_, user, orderProvider) => orderProvider..currentUser = user,
        child: OrderHistoryList(),
      ),
    );
  }
}
