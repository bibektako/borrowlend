import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:borrowlend/features/category/data/model/category_api_model.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/domain/repository/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRemoteRepository implements ICategoryRepository {
  final CategoryRemoteDataSource _categoryRemoteDataSource;

  CategoryRemoteRepository({
    required CategoryRemoteDataSource categoryRemoteDataSource,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource;

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategory() async {
    try {
      final categoryModels = await _categoryRemoteDataSource.getCategory();
      // Convert the List<CategoryApiModel> to List<CategoryEntity>
      final categoryEntities = CategoryApiModel.toEntityList(categoryModels);
      return Right(categoryEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}