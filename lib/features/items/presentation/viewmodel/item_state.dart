import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';

enum ItemStatus { initial, loading, success, failure }

class ItemState extends Equatable {
  final ItemStatus status;

  final List<ItemEntity> items;
  final List<ItemEntity> bookmarkedItems;
  final Set<String> bookmarkedItemIds;

  final String? errorMessage;

  const ItemState({
    required this.status,
    required this.items,
    required this.bookmarkedItems,
    required this.bookmarkedItemIds,

    this.errorMessage,
  });

  factory ItemState.initial() {
    return const ItemState(
      status: ItemStatus.initial,
      items: [],
      bookmarkedItems: [],
      bookmarkedItemIds: {},

      errorMessage: null,
    );
  }

  ItemState copyWith({
    ItemStatus? status,
    List<ItemEntity>? items,
    List<ItemEntity>? bookmarkedItems,
    Set<String>? bookmarkedItemIds, // Add to copyWith

    String? errorMessage,
  }) {
    return ItemState(
      status: status ?? this.status,
      items: items ?? this.items,
      bookmarkedItems: bookmarkedItems ?? this.bookmarkedItems,
      bookmarkedItemIds:
          bookmarkedItemIds ?? this.bookmarkedItemIds, 

      errorMessage:
          status == ItemStatus.failure
              ? (errorMessage ?? this.errorMessage)
              : null,
    );
  }

  @override
  List<Object?> get props => [status, items, bookmarkedItems, errorMessage];
}
