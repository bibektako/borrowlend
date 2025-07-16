
import 'package:borrowlend/features/category/data/model/category_api_model.dart';

abstract interface class ICategoryDataSource{
  Future<List<CategoryApiModel>> getCategory();
}