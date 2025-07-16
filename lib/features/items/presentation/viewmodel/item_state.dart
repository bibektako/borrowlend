import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:equatable/equatable.dart';

class ItemState extends Equatable {
  final bool isLoading;
  final List<ItemEntity> items;
  final String? errorMessage;

  const ItemState({
    required this.isLoading,
    required this.items,
    this.errorMessage,
  });

  factory ItemState.initial() {
    return const ItemState(isLoading: false, items: [], errorMessage: null);
  }

  ItemState copyWith({
    bool? isLoading,
    List<ItemEntity>? items,
    String? errorMessage,
  }) {
    return ItemState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, items, errorMessage];
}