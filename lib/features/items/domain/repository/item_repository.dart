import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IItemRepository {
  Future<Either<Failure, List<ItemEntity>>> getAllItems({Map<String, dynamic>? params});

  Future<Either<Failure, List<ItemEntity>>> getMyItems();

  Future<Either<Failure, void>> createItem(ItemEntity item);

  Future<Either<Failure, void>> updateItem(ItemEntity item);

  Future<Either<Failure, void>> deleteItem(String id);
}
