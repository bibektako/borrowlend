import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/review/data/datasource/review_datasource.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:borrowlend/features/review/domain/repository/review_repository.dart';
import 'package:dartz/dartz.dart';

class RemoteReviewRepository implements IReviewRepository {
  final IReviewDataSource _dataSource;

  RemoteReviewRepository({required IReviewDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, void>> createReview(ReviewEntity review) async {
    try {
      await _dataSource.createReview(review);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviews(String itemId) async {
    try {
      final reviews = await _dataSource.getReviews(itemId);
      return Right(reviews);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateReview(
      String reviewId, double rating, String comment) async {
    try {
      await _dataSource.updateReview(reviewId, rating, comment);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await _dataSource.deleteReview(reviewId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
}