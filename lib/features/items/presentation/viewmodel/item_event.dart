import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class LoadAllItemsEvent extends ItemEvent {}

class LoadMyItemsEvent extends ItemEvent {}


class CreateItemEvent extends ItemEvent {
  final ItemEntity item;

  const CreateItemEvent({
    required this.item,
  });

  @override
  List<Object> get props => [item];
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

class ToggleBookmarkEvent extends ItemEvent {
  final String itemId;
  final bool isCurrentlyBookmarked;

  const ToggleBookmarkEvent({
    required this.itemId,
    required this.isCurrentlyBookmarked,
  });
  @override
  List<Object> get props => [itemId, isCurrentlyBookmarked];

}

class LoadBookmarkedItemsEvent extends ItemEvent {}



class FormFieldChanged extends ItemEvent {
  final String? name;
  final String? description;
  final String? price;
    final CategoryEntity? category;

  final List<String>? imagePaths;

  const FormFieldChanged({this.name, this.description, this.price, this.category, this.imagePaths});
}

class LoadItemForEditing extends ItemEvent {
  final ItemEntity item;
  const LoadItemForEditing({required this.item});
}

class SubmitAddItemForm extends ItemEvent {}

class SubmitEditItemForm extends ItemEvent {}


