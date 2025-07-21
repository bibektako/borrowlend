import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, void>> createReview(ReviewEntity review);

  Future<Either<Failure, List<ReviewEntity>>> getReviews(String itemId);
  
  Future<Either<Failure, void>> deleteReview(String reviewId);

 Future<Either<Failure, void>> updateReview(String reviewId, double rating, String comment);

  
}