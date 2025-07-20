import 'package:borrowlend/features/items/domain/use_case/get_my_items_usecase.dart';
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
  final GetMyItemsUseCase _getMyItemsUseCase;

  ItemViewModel({
    required GetAllItemsUsecase getAllItemsUsecase,
    required CreateItemUsecase createItemUsecase,
    required UpdateItemUsecase updateItemUsecase,
    required DeleteItemUsecase deleteItemUsecase,
    required AddBookmarkUseCase addBookmarkUseCase,
    required RemoveBookmarkUseCase removeBookmarkUseCase,
    required GetBookmarksUseCase getBookmarksUseCase,
    required GetMyItemsUseCase getMyItemsUsecase,
  }) : _getAllItemsUsecase = getAllItemsUsecase,
       _createItemUsecase = createItemUsecase,
       _updateItemUsecase = updateItemUsecase,
       _deleteItemUsecase = deleteItemUsecase,
       _addBookmarkUseCase = addBookmarkUseCase,
       _removeBookmarkUseCase = removeBookmarkUseCase,
       _getBookmarksUseCase = getBookmarksUseCase,
       _getMyItemsUseCase = getMyItemsUsecase,
       super(ItemState.initial()) {
    on<LoadAllItemsEvent>(_onLoadAllItems);
    on<LoadMyItemsEvent>(_onLoadMyItems);
    on<LoadBookmarkedItemsEvent>(_onLoadBookmarkedItems);
    on<ToggleBookmarkEvent>(_onToggleBookmark);

    // Register event handlers for CRUD
    on<DeleteItemEvent>(_onDeleteItem);

    // --- THIS IS THE FIX ---
    // You MUST register the handlers for every event your UI dispatches.
    on<LoadItemForEditing>(_onLoadItemForEditing);
    on<FormFieldChanged>(_onFormFieldChanged);
    on<CreateItemEvent>(
      _onCreateItem,
    ); // Using CreateItemEvent for form submission
    on<UpdateItemEvent>(_onUpdateItem);
    on<SubmitAddItemForm>(_onSubmitAddItemForm);
    on<SubmitEditItemForm>(_onSubmitEditItemForm);
    //
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
    final bookmarkedItemsResult =
        results[1] as Either<Failure, List<ItemEntity>>;

    if (allItemsResult.isLeft() || bookmarkedItemsResult.isLeft()) {
      final errorMessage =
          allItemsResult.isLeft()
              ? (allItemsResult as Left).value.message
              : (bookmarkedItemsResult as Left).value.message;

      emit(
        state.copyWith(status: ItemStatus.failure, errorMessage: errorMessage),
      );
      return;
    }

    final allItems = allItemsResult.getOrElse(() => []);
    final bookmarkedItems = bookmarkedItemsResult.getOrElse(() => []);
    final bookmarkedIds = bookmarkedItems.map((item) => item.id!).toSet();

    final mergedItems =
        allItems.map((item) {
          if (bookmarkedIds.contains(item.id)) {
            return item.copyWith(isBookmarked: true);
          }
          return item.copyWith(isBookmarked: false);
        }).toList();

    emit(
      state.copyWith(
        status: ItemStatus.success,
        items: mergedItems,
        bookmarkedItems: bookmarkedItems,
        bookmarkedItemIds: bookmarkedIds,
      ),
    );
  }

  Future<void> _onCreateItem(
    CreateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));

    final result = await _createItemUsecase(event.item);

    result.fold(
      (failure) => emit(
        state.copyWith(
          formStatus: FormStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(state.copyWith(formStatus: FormStatus.success));
         emit(state.copyWith(formStatus: FormStatus.initial));
        add(LoadAllItemsEvent());
        add(LoadMyItemsEvent());
      },
    );
  }

  Future<void> _onUpdateItem(
    UpdateItemEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    final result = await _updateItemUsecase(event.itemToUpdate);
    result.fold(
      (failure) => emit(
        state.copyWith(
          formStatus: FormStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(state.copyWith(formStatus: FormStatus.success));
           emit(state.copyWith(formStatus: FormStatus.initial));

        add(LoadAllItemsEvent());
        add(LoadMyItemsEvent());
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

    final toggledItem =
        originalState.items.firstWhereOrNull(
          (item) => item.id == event.itemId,
        ) ??
        originalState.bookmarkedItems.firstWhereOrNull(
          (item) => item.id == event.itemId,
        );

    if (toggledItem == null) {
      emit(
        state.copyWith(
          status: ItemStatus.failure,
          errorMessage: "Error: Could not find the item to bookmark.",
        ),
      );
      return;
    }

    final updatedItem = toggledItem.copyWith(
      isBookmarked: !toggledItem.isBookmarked,
    );

    final updatedItemsList =
        originalState.items.map((item) {
          return item.id == event.itemId ? updatedItem : item;
        }).toList();

    List<ItemEntity> updatedBookmarksList;
    if (updatedItem.isBookmarked) {
      updatedBookmarksList = List.from(originalState.bookmarkedItems)
        ..add(updatedItem);
    } else {
      updatedBookmarksList =
          originalState.bookmarkedItems
              .where((item) => item.id != event.itemId)
              .toList();
    }

    final newBookmarkedIds =
        updatedBookmarksList.map((item) => item.id!).toSet();

    emit(
      state.copyWith(
        items: updatedItemsList,
        bookmarkedItems: updatedBookmarksList,
        bookmarkedItemIds: newBookmarkedIds,
        status: ItemStatus.success,
      ),
    );

    final result =
        event.isCurrentlyBookmarked
            ? await _removeBookmarkUseCase(event.itemId)
            : await _addBookmarkUseCase(event.itemId);

    result.fold((failure) {
      emit(
        originalState.copyWith(
          status: ItemStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }, (_) {});
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

  Future<void> _onLoadMyItems(
    LoadMyItemsEvent event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(status: ItemStatus.loading));
    final result = await _getMyItemsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ItemStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) =>
          emit(state.copyWith(status: ItemStatus.success, myItems: items)),
    );
  }

  void _onLoadItemForEditing(
    LoadItemForEditing event,
    Emitter<ItemState> emit,
  ) {
    emit(
      state.copyWith(
        itemToEdit: event.item,
        name: event.item.name,
        description: event.item.description,
        price: event.item.borrowingPrice.toStringAsFixed(0),
        imagePaths: event.item.imageUrls,
        selectedCategory: event.item.category,
        formStatus: FormStatus.initial,
      ),
    );
  }

  void _onFormFieldChanged(FormFieldChanged event, Emitter<ItemState> emit) {
    emit(
      state.copyWith(
        name: event.name ?? state.name,
        description: event.description ?? state.description,
        price: event.price ?? state.price,
        imagePaths: event.imagePaths ?? state.imagePaths,
        selectedCategory: event.category ?? state.selectedCategory,
      ),
    );
  }

  Future<void> _onSubmitAddItemForm(
    SubmitAddItemForm event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    final newItem = ItemEntity(
      name: state.name,
      description: state.description,
      borrowingPrice: double.tryParse(state.price) ?? 0,
      imageUrls: state.imagePaths,
      category: state.selectedCategory,
    );
    add(CreateItemEvent(item: newItem));
  }

  Future<void> _onSubmitEditItemForm(
    SubmitEditItemForm event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    final updatedItem = state.itemToEdit!.copyWith(
      name: state.name,
      description: state.description,
      borrowingPrice: double.tryParse(state.price) ?? 0,
      imageUrls: state.imagePaths,
      category: state.selectedCategory,
    );
    add(UpdateItemEvent(itemToUpdate: updatedItem));
  }
}
