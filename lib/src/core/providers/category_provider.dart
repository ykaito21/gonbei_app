import '../models/category_model.dart';
import '../services/api_path.dart';
import '../services/database_service.dart';
import 'base_provider.dart';

class CategoryProvider extends BaseProvider {
  final _dbService = DatabaseService.instance;
  List<CategoryModel> _categoryList = [];
  List<CategoryModel> get categoryList => [..._categoryList];

  Future<void> fetchCategoryList(String lang) async {
    try {
      // setViewState(ViewState.Busy);
      final res = await _dbService.getSelectedDataCollection(
        path: ApiPath.categories(),
        referenceTag: 'lang',
        referenceId: lang,
        orderBy: 'createdAt',
        descending: false,
      );
      List<CategoryModel> categoryList = res.documents.map((doc) {
        return CategoryModel.fromFirestore(doc.data, doc.documentID);
      }).toList();
      _categoryList = categoryList;
      setViewState(ViewState.Retrieved);
    } catch (e) {
      setViewState(ViewState.Error);
      print(e);
    }
  }
}
