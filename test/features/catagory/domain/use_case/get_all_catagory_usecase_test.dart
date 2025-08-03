import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/domain/repository/category_repository.dart';
import 'package:borrowlend/features/category/domain/use_case/get_all_category_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// --- Mock Class ---
class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  late GetAllCategoryUsecase usecase;
  late MockCategoryRepository mockRepository;

  setUp(() {
    mockRepository = MockCategoryRepository();
    usecase = GetAllCategoryUsecase(categoryRepository: mockRepository);
  });

  final tCategories = [
    const CategoryEntity(categoryId: '1', category: 'Electronics', category_image: 'http://image1.png'),
    const CategoryEntity(categoryId: '2', category: 'Books', category_image: 'http://image2.png'),
  ];

  group('GetAllCategoryUsecase', () {
    test(
      'should return a list of CategoryEntity on success',
      () async {
        // Arrange
        when(() => mockRepository.getCategory())
            .thenAnswer((_) async => Right(tCategories));

        // Act
        final result = await usecase();

        // Assert
        expect(result, Right(tCategories));
        verify(() => mockRepository.getCategory()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return a Failure when repository call fails',
      () async {
        // Arrange
        const failure = RemoteDatabaseFailure(message: 'Failed to fetch categories');
        when(() => mockRepository.getCategory())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase();

        // Assert
        expect(result, const Left(failure));
        verify(() => mockRepository.getCategory()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
