import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/data/data_source/bookmark_datasource.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/bookmark_repository.dart';
import 'package:dartz/dartz.dart';

class BookmarkRemoteRepository implements IBookmarkRepository {
  final IBookmarkDataSource _dataSource;

  BookmarkRemoteRepository(this._dataSource);

  @override
  Future<Either<Failure, void>> addBookmark(String itemId) async {
    try {
      await _dataSource.addBookmark(itemId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(String itemId) async {
    try {
      await _dataSource.removeBookmark(itemId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getBookmarkedItems() async {
    try {
      final itemModels = await _dataSource.getBookmarkedItems();
      
      final itemEntities = itemModels
          .map((model) => model.toEntity(isBookmarked: true))
          .toList();
          
      return Right(itemEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}