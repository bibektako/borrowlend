import 'package:dartz/dartz.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:collection/collection.dart';


import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/add_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/get_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/remove_bookmark_usecase.dart';
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
  final AddBookmarkUseCase _addBookmarkUseCase;
  final RemoveBookmarkUseCase _removeBookmarkUseCase;
  final GetBookmarksUseCase _getBookmarksUseCase;

  ItemViewModel({
    required GetAllItemsUsecase getAllItemsUsecase,
    required CreateItemUsecase createItemUsecase,
    required UpdateItemUsecase updateItemUsecase,
    required DeleteItemUsecase deleteItemUsecase,
    required AddBookmarkUseCase addBookmarkUseCase,
    required RemoveBookmarkUseCase removeBookmarkUseCase,
    required GetBookmarksUseCase getBookmarksUseCase,
  }) : _getAllItemsUsecase = getAllItemsUsecase,
       _createItemUsecase = createItemUsecase,
       _updateItemUsecase = updateItemUsecase,
       _deleteItemUsecase = deleteItemUsecase,
       _addBookmarkUseCase = addBookmarkUseCase,
       _removeBookmarkUseCase = removeBookmarkUseCase,
       _getBookmarksUseCase = getBookmarksUseCase,
       super(ItemState.initial()) {
    on<LoadAllItemsEvent>(_onLoadAllItems);
    on<CreateItemEvent>(_onCreateItem);
    on<UpdateItemEvent>(_onUpdateItem);
    on<DeleteItemEvent>(_onDeleteItem);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
    on<LoadBookmarkedItemsEvent>(_onLoadBookmarkedItems);
  }

  Future<void> _onLoadAllItems(
    LoadAllItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final results = await Future.wait([
      _getAllItemsUsecase(),
      _getBookmarksUseCase(),
    ]);

    final allItemsResult = results[0] as Either<Failure, List<ItemEntity>>;
    final bookmarkedItemsResult = results[1] as Either<Failure, List<ItemEntity>>;

     if (allItemsResult.isLeft() || bookmarkedItemsResult.isLeft()) {
      final errorMessage = allItemsResult.isLeft()
          ? (allItemsResult as Left).value.message
          : (bookmarkedItemsResult as Left).value.message;

      emit(state.copyWith(
        status: ItemStatus.failure,
        errorMessage: errorMessage,
      ));
      return;
    }

    final allItems = allItemsResult.getOrElse(() => []);
    final bookmarkedItems = bookmarkedItemsResult.getOrElse(() => []);
    final bookmarkedIds = bookmarkedItems.map((item) => item.id!).toSet();

    final mergedItems = allItems.map((item) {
      if (bookmarkedIds.contains(item.id)) {
        return item.copyWith(isBookmarked: true);
      }
      return item.copyWith(isBookmarked: false);
    }).toList();

    emit(state.copyWith(
      status: ItemStatus.success,
      items: mergedItems,
      bookmarkedItems: bookmarkedItems,
      bookmarkedItemIds: bookmarkedIds,
    ));
  }

  // --- CORRECTED ---
  Future<void> _onCreateItem(
    CreateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));
    // ... params creation is correct ...
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
      (failure) => emit(
        state.copyWith(
          status: ItemStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        add(LoadAllItemsEvent()); // This pattern is good, it reloads the list
      },
    );
  }

  Future<void> _onUpdateItem(
    UpdateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));
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
      (failure) => emit(
        state.copyWith(
          status: ItemStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        add(LoadAllItemsEvent());
      },
    );
  }

  Future<void> _onDeleteItem(
    DeleteItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));
    final params = DeleteItemParams(id: event.itemId);
    final result = await _deleteItemUsecase(params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ItemStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        add(LoadAllItemsEvent());
      },
    );
  }


  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter<ItemState> emit,
  ) async {
    final originalState = state;

    
    final toggledItem = originalState.items.firstWhereOrNull((item) => item.id == event.itemId) ??
                        originalState.bookmarkedItems.firstWhereOrNull((item) => item.id == event.itemId);
    
   
    if (toggledItem == null) {
      emit(state.copyWith(
        status: ItemStatus.failure,
        errorMessage: "Error: Could not find the item to bookmark."
      ));
      return; // Stop execution
    }

    final updatedItem = toggledItem.copyWith(isBookmarked: !toggledItem.isBookmarked);

    final updatedItemsList = originalState.items.map((item) {
      return item.id == event.itemId ? updatedItem : item;
    }).toList();

    List<ItemEntity> updatedBookmarksList;
    if (updatedItem.isBookmarked) {
      updatedBookmarksList = List.from(originalState.bookmarkedItems)..add(updatedItem);
    } else {
      updatedBookmarksList = originalState.bookmarkedItems
          .where((item) => item.id != event.itemId)
          .toList();
    }
    
    final newBookmarkedIds = updatedBookmarksList.map((item) => item.id!).toSet();

    emit(
      state.copyWith(
        items: updatedItemsList,
        bookmarkedItems: updatedBookmarksList,
        bookmarkedItemIds: newBookmarkedIds,
        status: ItemStatus.success,
      ),
    );

    final result = event.isCurrentlyBookmarked
        ? await _removeBookmarkUseCase(event.itemId)
        : await _addBookmarkUseCase(event.itemId);

    result.fold(
      (failure) {
        emit(
          originalState.copyWith(
            status: ItemStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (_) {  },
    );
  }
  Future<void> _onLoadBookmarkedItems(
    LoadBookmarkedItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));
    final result = await _getBookmarksUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ItemStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (bookmarks) => emit(
        state.copyWith(status: ItemStatus.success, bookmarkedItems: bookmarks),
      ),
    );
  }
}
