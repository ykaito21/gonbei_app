import '../models/product_model.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';
import 'base_provider.dart';

class ProductProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  List<ProductModel> _productList = [];
  List<ProductModel> get productList => [..._productList];

  Future<void> fetchProductList(String lang) async {
    try {
      // setViewState(ViewState.Busy);
      final res = await _dbService.getSelectedDataCollection(
        path: ApiPath.products(),
        referenceTag: 'lang',
        referenceId: lang,
        orderBy: 'createdAt',
        descending: false,
      );
      List<ProductModel> productList = res.documents.map((doc) {
        return ProductModel.fromFirestore(doc.data, doc.documentID);
      }).toList();
      _productList = productList;
      setViewState(ViewState.Retrieved);
    } catch (e) {
      setViewState(ViewState.Error);
      print(e);
    }
  }

  List<ProductModel> getCategoryProductList(String _categoryId) {
    return _productList
        .where((product) => product.categoryId == _categoryId)
        .toList();
  }
}
