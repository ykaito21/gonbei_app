import 'package:flutter/material.dart';
import 'package:gonbei_app/src/ui/screens/product_detail_screen.dart';
import '../../../app_localizations.dart';
import '../../../core/models/product_model.dart';
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
      case RoutePath.productDetailScreen:
        if (args is ProductModel) {
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productItem: args,
            ),
          );
        }
        return _errorRoute();

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
