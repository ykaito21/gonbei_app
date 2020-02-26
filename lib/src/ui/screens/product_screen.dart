import 'package:flutter/material.dart';
import 'package:gonbei_app/src/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/providers/base_provider.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/product_provider.dart';
import '../../core/providers/product_screen_provider.dart';
import '../global/style_list.dart';
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
    final categoryProviderViewState =
        Provider.of<CategoryProvider>(context).viewState;
    final productProviderViewState =
        Provider.of<ProductProvider>(context).viewState;
    if (categoryProviderViewState == ViewState.Error ||
        productProviderViewState == ViewState.Error)
      return StyleList.errorViewState(
          AppLocalizations.of(context).translate('error'));
    if (categoryProviderViewState != ViewState.Retrieved ||
        productProviderViewState != ViewState.Retrieved)
      return StyleList.loadingViewState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: StyleList.verticalHorizontalpadding1020,
          child: Text(
            AppLocalizations.of(context).translate('musubitate'),
            style: StyleList.baseTitleTextStyle,
          ),
        ),
        Container(
          height: 100.0,
          padding: StyleList.horizontalPadding5,
          child: CategoryList(),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Expanded(
          child: ProductList(),
        ),
      ],
    );
  }
}
