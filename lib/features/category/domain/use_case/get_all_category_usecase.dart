import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/domain/repository/category_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCategoryUsecase implements UsecaseWithoutParams<List<CategoryEntity>>{
  final ICategoryRepository categoryRepository;

  GetAllCategoryUsecase({required this.categoryRepository});
  @override
  Future<Either<Failure, List<CategoryEntity>>> call() async{
    return await categoryRepository.getCategory();
  }
}