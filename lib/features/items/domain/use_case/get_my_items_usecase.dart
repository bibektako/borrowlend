// lib/features/items/domain/use_case/get_my_items_usecase.dart
import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';

class GetMyItemsUseCase implements UsecaseWithoutParams<List<ItemEntity>> {
  final IItemRepository _repository;
  GetMyItemsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ItemEntity>>> call() => _repository.getMyItems();
}