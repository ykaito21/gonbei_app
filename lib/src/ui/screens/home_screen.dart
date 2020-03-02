import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gonbei_app/src/core/models/cart_model.dart';
import 'package:gonbei_app/src/core/providers/cart_provider.dart';

import '../../core/providers/category_provider.dart';
import '../../core/providers/product_provider.dart';
import '../global/routes/route_generator.dart';
import '../global/extensions.dart';
import '../shared/widgets/stream_wrapper.dart';
import 'cart_screen.dart';
import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _navigators = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void didChangeDependencies() {
    final lang = context.lang;
    context.provider<CategoryProvider>().fetchCategoryList(lang);
    context.provider<ProductProvider>().fetchProductList(lang);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(context.provider<FirebaseUser>());
    final cartProvider = context.provider<CartProvider>();
    return WillPopScope(
      onWillPop: () async =>
          !await _navigators[_currentIndex].currentState.maybePop(),
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: false,
        tabBuilder: (context, index) {
          return CupertinoTabView(
            navigatorKey: _navigators[index],
            onGenerateRoute: RouteGenerator.generateRoute,
            builder: (context) {
              switch (index) {
                case 0:
                  return ProductScreen();
                case 1:
                  return CartScreen();
                default:
                  return Container();
              }
            },
          );
        },
        tabBar: CupertinoTabBar(
          border: Border(
            top: BorderSide(
              color: context.primaryColor,
              width: 0.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          backgroundColor: context.scaffoldBackgroundColor,
          activeColor: context.accentColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              icon: StreamBuilder<List<CartModel>>(
                stream: cartProvider.streamCart,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.isNotEmpty)
                    return Badge(
                      badgeColor: context.accentColor,
                      toAnimate: false,
                      badgeContent: _badgeText(context, snapshot.data.length),
                      child: Icon(Icons.shopping_cart),
                    );
                  return Icon(Icons.shopping_cart);
                },
              ),
            ),
          ],
          onTap: (index) {
            if (_currentIndex == index) {
              _navigators[index]
                  .currentState
                  .popUntil((route) => route.isFirst);
            }
            _currentIndex = index;
          },
        ),
      ),
    );
  }

  Widget _badgeText(BuildContext context, int quantity) {
    return Text(
      '$quantity',
      style: TextStyle(
        color: context.primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
