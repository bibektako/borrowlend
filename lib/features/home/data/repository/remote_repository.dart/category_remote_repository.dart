import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/home/data/data_source/remote_data_source/category_remote_data_source.dart';
import 'package:borrowlend/features/home/domain/entity/category_entity.dart';
import 'package:borrowlend/features/home/domain/repository/category_repository.dart';
import 'package:dartz/dartz.dart';

class CategoryRemoteRepository implements ICategoryRepository {
  final CategoryRemoteDataSource _categoryRemoteDataSource;
  CategoryRemoteRepository({
    required CategoryRemoteDataSource categoryRemoteDataSource,
  }) : _categoryRemoteDataSource = categoryRemoteDataSource;
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategory() async{

    try {
      final category = await _categoryRemoteDataSource.getCategory();
      return right(category);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
}