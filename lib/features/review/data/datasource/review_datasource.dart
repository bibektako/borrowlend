import 'package:borrowlend/features/review/domain/entity/review_entity.dart';

abstract interface class IReviewDataSource {
  Future<void> createReview(ReviewEntity review);
  Future<List<ReviewEntity>> getReviews(String itemId);
  Future<void> updateReview(String reviewId, double rating, String comment);
  Future<void> deleteReview(String reviewId);
}