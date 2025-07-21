import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/review/data/datasource/review_datasource.dart';
import 'package:borrowlend/features/review/data/dto/get_all_reviews_dto.dart';
import 'package:borrowlend/features/review/data/model/review_api_model.dart';
import 'package:borrowlend/features/review/domain/entity/review_entity.dart';
import 'package:dio/dio.dart';

class ReviewRemoteDataSource implements IReviewDataSource {
  final ApiService _apiService;

  ReviewRemoteDataSource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<void> createReview(ReviewEntity review) async {
    try {
      final reviewApiModel = ReviewApiModel.fromEntity(review);
      await _apiService.dio.post(
        ApiEndpoints.createReview, 
        data: reviewApiModel.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(e.error.toString());
    }
  }

  @override
  Future<List<ReviewEntity>> getReviews(String itemId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.reviews, 
        queryParameters: {'item_id': itemId},
      );
      final dto = GetAllReviewsDto.fromJson(response.data);
      return dto.data.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      throw Exception(e.error.toString());
    }
  }

  @override
  Future<void> updateReview(
    String reviewId,
    double rating,
    String comment,
  ) async {
    try {
      await _apiService.dio.put(
        ApiEndpoints.updateReview(reviewId),
        data: {'rating': rating, 'comment': comment},
      );
    } on DioException catch (e) {
      throw Exception(e.error.toString());
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _apiService.dio.delete(
        ApiEndpoints.deleteReview(reviewId),
      );
    } on DioException catch (e) {
      throw Exception(e.error.toString());
    }
  }
}