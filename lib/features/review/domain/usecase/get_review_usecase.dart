import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';

class GetReviewsUsecase implements UsecaseWithParams<List<ReviewEntity>, String> {
  final IReviewRepository _repository;

  GetReviewsUsecase({required IReviewRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(String itemId) async {
    return await _repository.getReviews(itemId);
  }
}