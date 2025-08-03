import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/presentation/view/my_items_view.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_event.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_state.dart';
import 'package:borrowlend/features/items/presentation/viewmodel/item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockItemViewModel extends Mock implements ItemViewModel {}
class FakeItemEvent extends Fake implements ItemEvent {}


void main() {
  late MockItemViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(FakeItemEvent()); // ✅ Fixes the error
  });

  const testCategory = CategoryEntity(
    categoryId: '1',
    category: 'Test Category',
    category_image: 'test.png',
  );

  const testItem = ItemEntity(
    id: 'item1',
    name: 'Camera',
    description: 'A good camera',
    borrowingPrice: 100,
    imageUrls: ['test.png'],
    category: testCategory,
    isBookmarked: false,
  );

  final baseState = ItemState(
    status: ItemStatus.initial,
    items: const [],
    bookmarkedItems: const [],
    bookmarkedItemIds: const {},
    myItems: const [],
    formStatus: FormStatus.initial,
    name: '',
    description: '',
    price: '',
    imagePaths: const [],
    selectedCategory: const CategoryEntity(
      categoryId: '',
      category: 'Select a Category',
      category_image: '',
    ),
    itemToEdit: null,
  );

  Widget buildTestableWidget(ItemState state) {
    when(() => mockViewModel.state).thenReturn(state);
    when(() => mockViewModel.stream).thenAnswer((_) => Stream.value(state));
    when(() => mockViewModel.add(any())).thenReturn(null);

    return MaterialApp(
      home: BlocProvider<ItemViewModel>.value(
        value: mockViewModel,
        child: const MyItemsView(),
      ),
    );
  }

  setUp(() {
    mockViewModel = MockItemViewModel();
  });


}
