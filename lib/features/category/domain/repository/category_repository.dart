import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ICategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategory();
}
