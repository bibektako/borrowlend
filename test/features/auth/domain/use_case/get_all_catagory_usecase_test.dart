import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/category/domain/entity/category_entity.dart';
import 'package:borrowlend/features/category/domain/repository/category_repository.dart';
import 'package:borrowlend/features/category/domain/use_case/get_all_category_usecase.dart';

// 1. Create a mock class for the ICategoryRepository using mocktail.
//    This allows us to simulate its behavior without a real data source.
class MockCategoryRepository extends Mock implements ICategoryRepository {}

void main() {
  // 2. Declare the variables that will be used across the tests.
  //    'late' indicates they will be initialized before use in setUp.
  late GetAllCategoryUsecase usecase;
  late MockCategoryRepository mockCategoryRepository;

  // 3. The setUp function runs before each test, ensuring a clean state.
  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetAllCategoryUsecase(categoryRepository: mockCategoryRepository);
  });

  // 4. Create sample data to be returned by the mock repository.
  //    This makes the tests predictable and easy to read.
  final tCategoriesList = [
    const CategoryEntity(
      categoryId: '1',
      category: 'Electronics',
      category_image: 'electronics.png',
    ),
    const CategoryEntity(
      categoryId: '2',
      category: 'Books',
      category_image: 'books.png',
    ),
  ];

  // 5. Group related tests together under a descriptive name.
  group('GetAllCategoryUsecase', () {

    // Test Case 1: The success scenario
    test(
      'should get a list of categories from the repository',
      () async {
        // --- ARRANGE ---
        // Configure the mock repository. When `getCategory` is called,
        // it should return a successful result (a Right) containing our sample list.
        when(() => mockCategoryRepository.getCategory())
            .thenAnswer((_) async => Right(tCategoriesList));

        // --- ACT ---
        // Execute the use case. Since it takes no parameters, we just call it.
        final result = await usecase();

        // --- ASSERT ---
        // Expect the result to be a Right containing the exact list we defined.
        expect(result, Right(tCategoriesList));

        // Verify that the `getCategory` method on the mock repository was called exactly once.
        verify(() => mockCategoryRepository.getCategory()).called(1);

        // Verify that no other methods were called on the mock repository.
        verifyNoMoreInteractions(mockCategoryRepository);
      },
    );

    // Test Case 2: The failure scenario
    test(
      'should return a Failure when the repository call is unsuccessful',
      () async {
        // --- ARRANGE ---
        // Define a sample failure object.
        const tFailure = RemoteDatabaseFailure(message: 'Could not connect to server');

        // Configure the mock repository to return the failure (a Left).
        when(() => mockCategoryRepository.getCategory())
            .thenAnswer((_) async => const Left(tFailure));

        // --- ACT ---
        // Execute the use case.
        final result = await usecase();

        // --- ASSERT ---
        // Expect the result to be a Left containing the specific failure object.
        expect(result, const Left(tFailure));

        // Verify that the `getCategory` method was still called.
        verify(() => mockCategoryRepository.getCategory()).called(1);
        
        // Verify that no other interactions occurred.
        verifyNoMoreInteractions(mockCategoryRepository);
      },
    );
  });
}