import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/category_provider.dart';
import 'core/providers/product_provider.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/payment_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/user_provider.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
  ...uiProviders,
];

List<SingleChildWidget> independentProviders = [
  Provider<AuthProvider>(
    create: (_) => AuthProvider.instance,
  ),
  StreamProvider<FirebaseUser>.value(value: AuthProvider.instance.user),
  ChangeNotifierProvider<CategoryProvider>(
    create: (_) => CategoryProvider(),
  ),
  ChangeNotifierProvider<ProductProvider>(
    create: (_) => ProductProvider(),
  ),
  ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
  ),
];

List<SingleChildWidget> dependentProviders = [
  ChangeNotifierProxyProvider<FirebaseUser, CartProvider>(
    create: (_) => CartProvider(),
    update: (_, user, cartProvier) => cartProvier..currentUser = user,
  ),
  ChangeNotifierProxyProvider<FirebaseUser, PaymentProvider>(
    create: (_) => PaymentProvider(),
    update: (_, user, paymentProvier) => paymentProvier..currentUser = user,
  ),
  ProxyProvider<FirebaseUser, UserProvider>(
    create: (_) => UserProvider(),
    update: (_, user, userProvider) => userProvider..currentUser = user,
    dispose: (_, userProvider) => userProvider.dispose(),
  ),
];

List<SingleChildWidget> uiProviders = [];
