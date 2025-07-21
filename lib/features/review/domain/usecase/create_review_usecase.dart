import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';

class CreateReviewUsecase implements UsecaseWithParams<void, ReviewEntity> {
  final IReviewRepository _repository;

  CreateReviewUsecase({required IReviewRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(ReviewEntity review) async {
    return await _repository.createReview(review);
  }
}