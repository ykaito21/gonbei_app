import 'package:flutter/material.dart';
import '../../../core/models/product_model.dart';
import '../../screens/home_screen.dart';
import '../../screens/auth_screen.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/profile_edit_screen.dart';
import '../../screens/account_settings_screen.dart';
import '../../screens/payment_methods_screen.dart';
import '../../screens/order_history_screen.dart';
import '../style_list.dart';
import '../extensions.dart';
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
      case RoutePath.authScreen:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AuthScreen(),
        );
      case RoutePath.accountSettingsScreen:
        return MaterialPageRoute(
          builder: (context) => AccountSettingsScreen(),
        );
      case RoutePath.orderHistoryScreen:
        return MaterialPageRoute(
          builder: (context) => OrderHistoryScreen(),
        );
      case RoutePath.paymentMethodsScreen:
        return MaterialPageRoute(
          builder: (context) => PaymentMethodsScreen(),
        );
      case RoutePath.profileEditScreen:
        return MaterialPageRoute(
          builder: (context) => ProfileEditScreen(),
        );

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
              context.translate('error'),
              style: StyleList.baseTitleTextStyle,
            ),
          ),
        );
      },
    );
  }
}
