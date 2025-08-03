import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/add_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/get_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/bookmark/remove_bookmark_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/create_item_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/delete_item_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/get_all_items_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/get_my_items_usecase.dart';
import 'package:borrowlend/features/items/domain/use_case/update_item_usecase.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockCreateItemUsecase extends Mock implements CreateItemUsecase {}

class MockUpdateItemUsecase extends Mock implements UpdateItemUsecase {}

class MockDeleteItemUsecase extends Mock implements DeleteItemUsecase {}

class MockAddBookmarkUsecase extends Mock implements AddBookmarkUseCase {}

class MockRemoveBookmarkUsecase extends Mock implements RemoveBookmarkUseCase {}

class MockGetBookmarksUsecase extends Mock implements GetBookmarksUseCase {}

class MockGetMyItemsUsecase extends Mock implements GetMyItemsUseCase {}

void main() {
  late ItemViewModel bloc;

  late MockGetAllItemsUsecase mockGetAllItems;
  late MockCreateItemUsecase mockCreateItem;
  late MockUpdateItemUsecase mockUpdateItem;
  late MockDeleteItemUsecase mockDeleteItem;
  late MockAddBookmarkUsecase mockAddBookmark;
  late MockRemoveBookmarkUsecase mockRemoveBookmark;
  late MockGetBookmarksUsecase mockGetBookmarks;
  late MockGetMyItemsUsecase mockGetMyItems;

  const category = CategoryEntity(categoryId: '1', category: 'Books', category_image: 'cat.png');

  final testItem = ItemEntity(
    id: '123',
    name: 'Camera',
    imageUrls: ['img.png'],
    description: 'Nice camera',
    borrowingPrice: 10,
    category: category,
  );

  setUp(() {
    mockGetAllItems = MockGetAllItemsUsecase();
    mockCreateItem = MockCreateItemUsecase();
    mockUpdateItem = MockUpdateItemUsecase();
    mockDeleteItem = MockDeleteItemUsecase();
    mockAddBookmark = MockAddBookmarkUsecase();
    mockRemoveBookmark = MockRemoveBookmarkUsecase();
    mockGetBookmarks = MockGetBookmarksUsecase();
    mockGetMyItems = MockGetMyItemsUsecase();

    bloc = ItemViewModel(
      getAllItemsUsecase: mockGetAllItems,
      createItemUsecase: mockCreateItem,
      updateItemUsecase: mockUpdateItem,
      deleteItemUsecase: mockDeleteItem,
      addBookmarkUseCase: mockAddBookmark,
      removeBookmarkUseCase: mockRemoveBookmark,
      getBookmarksUseCase: mockGetBookmarks,
      getMyItemsUsecase: mockGetMyItems,
    );
  });

  blocTest<ItemViewModel, ItemState>(
    'emits [loading, success] when CreateItemEvent succeeds',
    build: () {
      when(() => mockCreateItem(testItem)).thenAnswer((_) async => const Right(null));
      when(() => mockGetAllItems(null)).thenAnswer((_) async => Right([testItem]));
      when(() => mockGetBookmarks()).thenAnswer((_) async => const Right([]));
      when(() => mockGetMyItems()).thenAnswer((_) async => Right([testItem]));

      return bloc;
    },
    act: (bloc) => bloc.add(CreateItemEvent(item: testItem)),
    expect: () => [
      // Initial form submit loading
      isA<ItemState>().having((s) => s.status, 'status', ItemStatus.loading),
      isA<ItemState>().having((s) => s.formStatus, 'form success', FormStatus.success),
      isA<ItemState>().having((s) => s.formStatus, 'form reset', FormStatus.initial),
      // After LoadAllItemsEvent
      isA<ItemState>().having((s) => s.status, 'status', ItemStatus.success),
      // After LoadMyItemsEvent
      isA<ItemState>().having((s) => s.status, 'status', ItemStatus.loading),
      isA<ItemState>().having((s) => s.status, 'status', ItemStatus.success),
    ],
    verify: (_) {
      verify(() => mockCreateItem(testItem)).called(1);
      verify(() => mockGetAllItems(null)).called(1);
      verify(() => mockGetBookmarks()).called(1);
      verify(() => mockGetMyItems()).called(1);
    },
  );

}
