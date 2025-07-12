import 'package:borrowlend/features/home/domain/entity/category_entity.dart';

abstract interface class IHomeDataSource{
  Future<List<CategoryEntity>> getCategory();
}