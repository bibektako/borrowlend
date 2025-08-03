import 'package:bloc_test/bloc_test.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/auth_status.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/usecase/create_review_usecase.dart';
import 'package:borrowlend/features/review/domain/usecase/delete_review_usecae.dart';
import 'package:borrowlend/features/review/domain/usecase/get_review_usecase.dart';
import 'package:borrowlend/features/review/domain/usecase/update_review_usecase.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_event.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_state.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetReviewsUsecase extends Mock implements GetReviewsUsecase {}

class MockCreateReviewUsecase extends Mock implements CreateReviewUsecase {}

class MockUpdateReviewUsecase extends Mock implements UpdateReviewUsecase {}

class MockDeleteReviewUsecase extends Mock implements DeleteReviewUsecase {}

class MockSessionCubit extends Mock implements SessionCubit {}

void main() {
  late MockGetReviewsUsecase getReviewsUsecase;
  late MockCreateReviewUsecase createReviewUsecase;
  late MockUpdateReviewUsecase updateReviewUsecase;
  late MockDeleteReviewUsecase deleteReviewUsecase;
  late MockSessionCubit sessionCubit;
  late ReviewViewModel reviewBloc;

  const reviewUser = ReviewUserEntity(id: 'u1', username: 'testuser');
  final testReview = ReviewEntity(
    id: 'r1',
    rating: 4.5,
    comment: 'Excellent!',
    itemId: 'i1',
    user: reviewUser,
  );

  setUp(() {
    registerFallbackValue(testReview);

    getReviewsUsecase = MockGetReviewsUsecase();
    createReviewUsecase = MockCreateReviewUsecase();
    updateReviewUsecase = MockUpdateReviewUsecase();
    deleteReviewUsecase = MockDeleteReviewUsecase();
    sessionCubit = MockSessionCubit();

    reviewBloc = ReviewViewModel(
      getReviewsUsecase: getReviewsUsecase,
      createReviewUsecase: createReviewUsecase,
      updateReviewUsecase: updateReviewUsecase,
      deleteReviewUsecase: deleteReviewUsecase,
      sessionCubit: sessionCubit,
    );
  });

  group('ReviewViewModel', () {
    blocTest<ReviewViewModel, ReviewState>(
      'emits [ReviewLoading, ReviewSuccess] when ReviewsFetched succeeds',
      build: () {
        when(
          () => getReviewsUsecase('i1'),
        ).thenAnswer((_) async => Right([testReview]));
        return reviewBloc;
      },
      act: (bloc) => bloc.add(const ReviewsFetched(itemId: 'i1')),
      expect:
          () => [
            const ReviewLoading(),
            ReviewSuccess(reviews: [testReview]),
          ],
    );

    blocTest<ReviewViewModel, ReviewState>(
      'emits ReviewSuccess with error if not authenticated',
      build: () {
        when(
          () => sessionCubit.state,
        ).thenReturn(SessionState.unauthenticated());
        return reviewBloc;
      },
      seed: () => ReviewSuccess(reviews: [testReview]),
      act:
          (bloc) => bloc.add(
            const ReviewSubmitted(rating: 5.0, comment: 'Nice', itemId: 'i1'),
          ),
      expect:
          () => [
            ReviewSuccess(
              reviews: [testReview],
              successMessage: 'Error: You must be logged in to post a review.',
            ),
          ],
    );
  });
}
