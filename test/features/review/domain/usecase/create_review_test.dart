import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:borrowlend/features/review/domain/usecase/create_review_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewRepository extends Mock implements IReviewRepository {}

void main() {
  late CreateReviewUsecase usecase;
  late MockReviewRepository mockRepository;

  const testUser = ReviewUserEntity(
    id: 'user123',
    username: 'testuser',
  );

  const testReview = ReviewEntity(
    id: 'review1',
    rating: 4.5,
    comment: 'Great product!',
    itemId: 'item123',
    user: testUser,
    createdAt: null,
  );

  setUp(() {
    mockRepository = MockReviewRepository();
    usecase = CreateReviewUsecase(repository: mockRepository);
  });

  test('should return Right(void) when review creation succeeds', () async {
    // Arrange
    when(() => mockRepository.createReview(testReview))
        .thenAnswer((_) async => const Right(null));

    // Act
    final result = await usecase(testReview);

    // Assert
    expect(result, equals(const Right(null)));
    verify(() => mockRepository.createReview(testReview)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Left(Failure) when repository fails', () async {
    // Arrange
    final failure = ServerFailure(message: 'Failed to create review');

    when(() => mockRepository.createReview(testReview))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await usecase(testReview);

    // Assert
    expect(result, equals(Left(failure)));
    verify(() => mockRepository.createReview(testReview)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
