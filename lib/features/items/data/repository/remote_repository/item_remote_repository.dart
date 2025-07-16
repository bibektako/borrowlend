import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/data/data_source/remote_data_source/item_remote_datasource.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';

class ItemRemoteRepository implements IItemRepository {
  final ItemRemoteDatasource _itemRemoteDatasource;

  ItemRemoteRepository({required ItemRemoteDatasource itemRemoteDatasource})
      : _itemRemoteDatasource = itemRemoteDatasource;

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    try {
      final items = await _itemRemoteDatasource.getAllItems();
      return Right(items);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> createItem(ItemEntity item) {
    // TODO: implement createItem
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> deleteItem(String id) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> updateItem(ItemEntity item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, void>> createItem(ItemEntity item) async {
  //   try {
  //     await _itemRemoteDatasource.createItem(item);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(RemoteDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> updateItem(ItemEntity item) async {
  //   try {
  //     await _itemRemoteDatasource.updateItem(item);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(RemoteDatabaseFailure(message: e.toString()));
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> deleteItem(String id) async {
  //   try {
  //     await _itemRemoteDatasource.deleteItem(id);
  //     return const Right(null);
  //   } catch (e) {
  //     return Left(RemoteDatabaseFailure(message: e.toString()));
  //   }
  // }
}