import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllItemsUsecase implements UsecaseWithoutParams<List<ItemEntity>> {
  final IItemRepository _itemRepository;

  GetAllItemsUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, List<ItemEntity>>> call() {
    return _itemRepository.getAllItems();
  }
}