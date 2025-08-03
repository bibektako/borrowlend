import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:borrowlend/features/review/domain/usecase/get_review_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock class
class MockReviewRepository extends Mock implements IReviewRepository {}

// Fake data
const testUser = ReviewUserEntity(id: 'u1', username: 'testuser');

const testReview = ReviewEntity(
  id: 'r1',
  rating: 4.5,
  comment: 'Excellent!',
  itemId: 'i1',
  user: testUser,
  createdAt: null,
);

void main() {
  late MockReviewRepository mockRepository;
  late GetReviewsUsecase getReviewsUsecase;

  setUp(() {
    mockRepository = MockReviewRepository();
    getReviewsUsecase = GetReviewsUsecase(repository: mockRepository);
  });



  test('should return failure when repo fails', () async {
    final failure = ServerFailure(message: 'Failed to load reviews');

    // arrange
    when(
      () => mockRepository.getReviews('i1'),
    ).thenAnswer((_) async => Left(failure));

    // act
    final result = await getReviewsUsecase('i1');

    // assert
    expect(result, equals(Left(failure)));
    verify(() => mockRepository.getReviews('i1')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
