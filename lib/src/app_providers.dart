import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/category_provider.dart';
import 'core/providers/product_provider.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
  ...uiProviders,
];

List<SingleChildWidget> independentProviders = [
  StreamProvider<FirebaseUser>.value(value: AuthProvider().user),
  ChangeNotifierProvider<CategoryProvider>(
    create: (_) => CategoryProvider(),
  ),
  ChangeNotifierProvider<ProductProvider>(
    create: (_) => ProductProvider(),
  ),
];

List<SingleChildWidget> dependentProviders = [];

List<SingleChildWidget> uiProviders = [];
