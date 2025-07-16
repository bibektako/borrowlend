import 'package:borrowlend/features/items/domain/use_case/create_item_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/delete_item_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/get_all_items_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/update_item_usecase.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemViewModel extends Bloc<ItemEvent, ItemState> {
  final GetAllItemsUsecase _getAllItemsUsecase;
  final CreateItemUsecase _createItemUsecase;
  final UpdateItemUsecase _updateItemUsecase;
  final DeleteItemUsecase _deleteItemUsecase;

  ItemViewModel({
    required GetAllItemsUsecase getAllItemsUsecase,
    required CreateItemUsecase createItemUsecase,
    required UpdateItemUsecase updateItemUsecase,
    required DeleteItemUsecase deleteItemUsecase,
  })  : _getAllItemsUsecase = getAllItemsUsecase,
        _createItemUsecase = createItemUsecase,
        _updateItemUsecase = updateItemUsecase,
        _deleteItemUsecase = deleteItemUsecase,
        super(ItemState.initial()) {
    // Register event handlers
    on<LoadAllItemsEvent>(_onLoadAllItems);
    on<CreateItemEvent>(_onCreateItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
  }

  Future<void> _onLoadAllItems(
    LoadAllItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getAllItemsUsecase();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<void> _onCreateItem(
    CreateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final params = CreateItemParams(
      name: event.name,
      description: event.description,
      imageUrls: event.imageUrls,
      borrowingPrice: event.borrowingPrice,
      categoryId: event.category.id, 
      categoryName: event.category.name,
    );
    final result = await _createItemUsecase(params);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        add(LoadAllItemsEvent());
      },
    );
  }

  Future<void> _onUpdateItem(
    UpdateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final params = UpdateItemParams(
      id: event.itemToUpdate.id!, 
      name: event.itemToUpdate.name,
      description: event.itemToUpdate.description ?? '',
      imageUrls: event.itemToUpdate.imageUrls,
      borrowingPrice: event.itemToUpdate.borrowingPrice,
      category: event.itemToUpdate.category,
    );
    final result = await _updateItemUsecase(params);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        add(LoadAllItemsEvent());
      },
    );
  }

  Future<void> _onDeleteItem(
    DeleteItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final params = DeleteItemParams(id: event.itemId);
    final result = await _deleteItemUsecase(params);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        add(LoadAllItemsEvent());
      },
    );
  }
}