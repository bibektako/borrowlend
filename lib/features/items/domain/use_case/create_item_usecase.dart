import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';

class CreateItemUsecase implements UsecaseWithParams<void, ItemEntity> {
  final IItemRepository _itemRepository;

  CreateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, void>> call(ItemEntity params) async {
    return await _itemRepository.createItem(params);
  }
}