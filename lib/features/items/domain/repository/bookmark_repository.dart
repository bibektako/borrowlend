import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IBookmarkRepository {
  Future<Either<Failure, void>> addBookmark(String itemId);
  Future<Either<Failure, void>> removeBookmark(String itemId);
  Future<Either<Failure, List<ItemEntity>>> getBookmarkedItems();
}