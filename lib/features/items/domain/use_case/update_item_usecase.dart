import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateItemParams extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final double borrowingPrice;
  final CategoryEntity category;

  const UpdateItemParams({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.borrowingPrice,
    required this.category,
  });

  @override
  List<Object?> get props =>
      [id, name, description, imageUrls, borrowingPrice, category];
}

class UpdateItemUsecase implements UsecaseWithParams<void, UpdateItemParams> {
  final IItemRepository _itemRepository;

  UpdateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, void>> call(UpdateItemParams params) {
    final itemToUpdate = ItemEntity(
      id: params.id,
      name: params.name,
      description: params.description,
      imageUrls: params.imageUrls,
      borrowingPrice: params.borrowingPrice,
      category: params.category,
    );

    return _itemRepository.updateItem(itemToUpdate);
  }
}