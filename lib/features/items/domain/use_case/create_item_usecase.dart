import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateItemParams extends Equatable {
  final String name;
  final String description;
  final List<String> imageUrls;
  final double borrowingPrice;
  final String categoryId;
  final String categoryName;

  const CreateItemParams({
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.borrowingPrice,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        imageUrls,
        borrowingPrice,
        categoryId,
        categoryName,
      ];
}

class CreateItemUsecase implements UsecaseWithParams<void, CreateItemParams> {
  final IItemRepository _itemRepository;

  CreateItemUsecase({required IItemRepository itemRepository})
      : _itemRepository = itemRepository;

  @override
  Future<Either<Failure, void>> call(CreateItemParams params) {
    // This now works because id, rating, and owner are nullable in ItemEntity
    final item = ItemEntity(
      name: params.name,
      description: params.description,
      imageUrls: params.imageUrls,
      borrowingPrice: params.borrowingPrice,
      category: CategoryEntity(
        id: params.categoryId,
        name: params.categoryName,
      ),
    );

    return _itemRepository.createItem(item);
  }
}