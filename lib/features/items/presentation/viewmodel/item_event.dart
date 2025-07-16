import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class LoadAllItemsEvent extends ItemEvent {}

class CreateItemEvent extends ItemEvent {
  final String name;
  final String description;
  final List<String> imageUrls;
  final double borrowingPrice;
  final CategoryEntity category;

  const CreateItemEvent({
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.borrowingPrice,
    required this.category,
  });

  @override
  List<Object> get props => [name, description, imageUrls, borrowingPrice, category];
}

class UpdateItemEvent extends ItemEvent {
  final ItemEntity itemToUpdate;

  const UpdateItemEvent({required this.itemToUpdate});

  @override
  List<Object> get props => [itemToUpdate];
}


class DeleteItemEvent extends ItemEvent {
  final String itemId;

  const DeleteItemEvent({required this.itemId});

  @override
  List<Object> get props => [itemId];
}