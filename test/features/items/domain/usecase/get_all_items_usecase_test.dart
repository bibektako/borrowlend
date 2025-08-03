import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:borrowlend/features/items/domain/use_case/get_all_items_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// === Mock ===
class MockItemRepository extends Mock implements IItemRepository {}

void main() {
  late MockItemRepository mockItemRepository;
  late GetAllItemsUsecase usecase;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = GetAllItemsUsecase(itemRepository: mockItemRepository);
  });

  // === Dummy Data ===
  const testParams = {'search': 'camera'};
  const testCategory = CategoryEntity(categoryId: '1', category: 'Electronics', category_image: 'images/electronics.png');

  final testItems = [
    ItemEntity(
      id: 'item001',
      name: 'DSLR Camera',
      imageUrls: ['camera1.png'],
      description: 'A Canon DSLR camera',
      borrowingPrice: 15.0,
      category: testCategory,
    ),
    ItemEntity(
      id: 'item002',
      name: 'Tripod',
      imageUrls: ['tripod.png'],
      description: 'A sturdy tripod',
      borrowingPrice: 5.0,
      category: testCategory,
    ),
  ];

  test('should return list of ItemEntity on success', () async {
    // Arrange
    when(() => mockItemRepository.getAllItems(params: testParams))
        .thenAnswer((_) async => Right(testItems));

    // Act
    final result = await usecase(testParams);

    // Assert
    expect(result, Right(testItems));
    verify(() => mockItemRepository.getAllItems(params: testParams)).called(1);
    verifyNoMoreInteractions(mockItemRepository);
  });

  test('should return Failure when repository fails', () async {
    // Arrange
    const failure = RemoteDatabaseFailure(message: 'Server error');

    when(() => mockItemRepository.getAllItems(params: null))
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(null);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockItemRepository.getAllItems(params: null)).called(1);
    verifyNoMoreInteractions(mockItemRepository);
  });
}
