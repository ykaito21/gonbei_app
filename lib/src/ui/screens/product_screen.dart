import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/product_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/style_list.dart';
import '../global/extensions.dart';
import '../shared/widgets/base_app_bar.dart';
import '../widgets/category_list.dart';
import '../widgets/product_list.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(),
      body: ChangeNotifierProvider<ProductScreenProvider>(
        create: (context) => ProductScreenProvider(),
        child: _currentView(context),
      ),
    );
  }

  Widget _currentView(BuildContext context) {
    final categoryProvider = context.provider<CategoryProvider>(listen: true);
    final productProvider = context.provider<ProductProvider>(listen: true);
    if (categoryProvider.isError || productProvider.isError)
      return StyleList.errorViewState(context.translate('error'));
    if (!categoryProvider.isRetrieved || !productProvider.isRetrieved)
      return StyleList.loadingViewState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: StyleList.verticalHorizontalpadding1020,
          child: Text(
            context.translate('musubitate'),
            style: StyleList.baseTitleTextStyle,
          ),
        ),
        Container(
          height: 100.0,
          padding: StyleList.horizontalPadding5,
          child: CategoryList(),
        ),
        StyleList.verticalBox10,
        Expanded(
          child: ProductList(),
        ),
      ],
    );
  }
}
