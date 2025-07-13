import 'package:borrowlend/features/home/domain/entity/category_entity.dart';

abstract interface class ICategoryDataSource{
  Future<List<CategoryEntity>> getCategory();
}