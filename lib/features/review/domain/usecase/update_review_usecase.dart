import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateReviewParams extends Equatable {
  final String reviewId;
  final double rating;
  final String comment;

  const UpdateReviewParams({
    required this.reviewId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [reviewId, rating, comment];
}

class UpdateReviewUsecase implements UsecaseWithParams<void, UpdateReviewParams> {
  final IReviewRepository _repository;

  UpdateReviewUsecase({required IReviewRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(UpdateReviewParams params) async {
    return await _repository.updateReview(
       params.reviewId,
       params.rating,
       params.comment,
    );
  }
}