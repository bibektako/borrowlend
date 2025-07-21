import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/usecase/create_review_usecase.dart';
import 'package:borrowlend/features/review/domain/usecase/delete_review_usecae.dart';
import 'package:borrowlend/features/review/domain/usecase/get_review_usecase.dart';
import 'package:borrowlend/features/review/domain/usecase/update_review_usecase.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_event.dart';
import 'package:borrowlend/features/review/presentation/view_model/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewViewModel extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUsecase _getReviewsUsecase;
  final CreateReviewUsecase _createReviewUsecase;
  final UpdateReviewUsecase _updateReviewUsecase;
  final DeleteReviewUsecase _deleteReviewUsecase;
  final LoginViewModel loginViewModel;

  ReviewViewModel({
    required GetReviewsUsecase getReviewsUsecase,
    required CreateReviewUsecase createReviewUsecase,
    required UpdateReviewUsecase updateReviewUsecase,
    required DeleteReviewUsecase deleteReviewUsecase,
    required this.loginViewModel,
  })  : _getReviewsUsecase = getReviewsUsecase,
        _createReviewUsecase = createReviewUsecase,
        _updateReviewUsecase = updateReviewUsecase,
        _deleteReviewUsecase = deleteReviewUsecase,
        super(const ReviewInitial()) {
    on<ReviewsFetched>(_onReviewsFetched);
    on<ReviewSubmitted>(_onReviewSubmitted);
    on<ReviewUpdated>(_onReviewUpdated);
    on<ReviewDeleted>(_onReviewDeleted);
  }

  Future<void> _onReviewsFetched(
    ReviewsFetched event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());
    final result = await _getReviewsUsecase(event.itemId);
    result.fold(
      (failure) => emit(ReviewFailure(message: failure.message)),
      (reviews) => emit(ReviewSuccess(reviews: reviews)),
    );
  }

  Future<void> _onReviewSubmitted(
    ReviewSubmitted event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewSuccess) return;
    final currentReviews = (state as ReviewSuccess).reviews;
    final loginState = loginViewModel.state;
    print("--- DEBUGGING REVIEW SUBMISSION ---");
    print("LoginViewModel instance hashCode: ${loginViewModel.hashCode}");
    print("Current LoginState is: ${loginState.toString()}");
    print("Is login successful? --> ${loginState.isSuccess}");
    print("Does login state have a user? --> ${loginState.user != null}");
    


    if (!loginState.isSuccess || loginState.user == null) {
      emit(ReviewSuccess(
        reviews: currentReviews,
        successMessage: 'Error: You must be logged in to post a review.',
      ));
      return;
    }
    print("Check PASSED. Proceeding to create review.");
    emit(ReviewActionInProgress(currentReviews));

    emit(ReviewActionInProgress(currentReviews));

    final currentUser = ReviewUserEntity(
      id: loginState.user!.userId!,
      username: loginState.user!.username,
    );

    final reviewEntity = ReviewEntity(
      rating: event.rating,
      comment: event.comment,
      itemId: event.itemId,
      user: currentUser, // Use the REAL user data
    );

    final result = await _createReviewUsecase(reviewEntity);

    result.fold(
      (failure) {
        emit(ReviewSuccess(reviews: currentReviews, successMessage: 'Error: ${failure.message}'));
      },
      (_) {
        add(ReviewsFetched(itemId: event.itemId));
      },
    );
  }

  Future<void> _onReviewUpdated(
    ReviewUpdated event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewSuccess) return;
    final currentReviews = (state as ReviewSuccess).reviews;

    emit(ReviewActionInProgress(currentReviews));

    final params = UpdateReviewParams(
      reviewId: event.reviewId,
      rating: event.rating,
      comment: event.comment,
    );
    final result = await _updateReviewUsecase(params);

    result.fold(
      (failure) => emit(ReviewSuccess(reviews: currentReviews, successMessage: 'Error: ${failure.message}')),
      (_) {
        final itemId = currentReviews.firstWhere((r) => r.id == event.reviewId).itemId;
        add(ReviewsFetched(itemId: itemId));
      },
    );
  }

  Future<void> _onReviewDeleted(
    ReviewDeleted event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewSuccess) return;
    final currentReviews = (state as ReviewSuccess).reviews;

    emit(ReviewActionInProgress(currentReviews));
    
    final result = await _deleteReviewUsecase(event.reviewId);

    result.fold(
      (failure) => emit(ReviewSuccess(reviews: currentReviews, successMessage: 'Error: ${failure.message}')),
      (_) {
        final reviewToDelete = currentReviews.firstWhere((r) => r.id == event.reviewId);
        add(ReviewsFetched(itemId: reviewToDelete.itemId));
      },
    );
  }
}