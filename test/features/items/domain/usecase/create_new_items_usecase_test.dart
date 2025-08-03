import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:borrowlend/features/items/domain/use_case/create_item_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// === Mock Repository ===
class MockItemRepository extends Mock implements IItemRepository {}

void main() {
  late MockItemRepository mockItemRepository;
  late CreateItemUsecase usecase;

  setUp(() {
    mockItemRepository = MockItemRepository();
    usecase = CreateItemUsecase(itemRepository: mockItemRepository);
  });

  const testCategory = CategoryEntity(
    categoryId: '1',
    category: 'Electronics',
    category_image: 'uploads/electronics.png',
  );

  final testItem = ItemEntity(
    name: 'Camera',
    imageUrls: ['img1.png'],
    description: 'A DSLR camera',
    borrowingPrice: 20.0,
    category: testCategory,
  );

  test('should call createItem and return success', () async {
    // Arrange
    when(
      () => mockItemRepository.createItem(testItem),
    ).thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(testItem);

    // Assert
    expect(result, const Right(null));
    verify(() => mockItemRepository.createItem(testItem)).called(1);
    verifyNoMoreInteractions(mockItemRepository);
  });

  test('should return Failure when createItem fails', () async {
    // Arrange
    const failure = RemoteDatabaseFailure(message: 'Failed to create item');
    when(
      () => mockItemRepository.createItem(testItem),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await usecase(testItem);

    // Assert
    expect(result, const Left(failure));
    verify(() => mockItemRepository.createItem(testItem)).called(1);
    verifyNoMoreInteractions(mockItemRepository);
  });
}
