import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/bookmark_repository.dart';
import 'package:dartz/dartz.dart';

class GetBookmarksUseCase implements UsecaseWithoutParams<List<ItemEntity>> {
  final IBookmarkRepository _repository;
  GetBookmarksUseCase(this._repository);

  @override
  Future<Either<Failure, List<ItemEntity>>> call() => _repository.getBookmarkedItems();
}