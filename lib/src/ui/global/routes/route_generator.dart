import 'package:flutter/material.dart';
import '../../../app_localizations.dart';
import '../../screens/home_screen.dart';
import '../../screens/cart_screen.dart';

import '../style_list.dart';
import 'route_path.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RoutePath.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RoutePath.cartScreen:
        // if (args is Strring) {
        return MaterialPageRoute(
          builder: (context) => CartScreen(),
        );
      // }
      // return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text(
              AppLocalizations.of(context).translate('error'),
              style: StyleList.baseTitleTextStyle,
            ),
          ),
        );
      },
    );
  }
}
