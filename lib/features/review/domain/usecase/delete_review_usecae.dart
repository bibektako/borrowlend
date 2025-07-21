import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteReviewUsecase implements UsecaseWithParams<void, String> {
  final IReviewRepository _repository;

  DeleteReviewUsecase({required IReviewRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(String reviewId) async {
    return await _repository.deleteReview(reviewId);
  }
}