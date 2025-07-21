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
      final response = await _apiService.dio.post(
        ApiEndpoints.createReview,
        data: reviewApiModel.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create review: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to create review: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<ReviewEntity>> getReviews(String itemId) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getReviews,
        queryParameters: {'item_id': itemId},
      );
      if (response.statusCode == 200) {
        final dto = GetAllReviewsDto.fromJson(response.data);
        return dto.data.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('Failed to fetch reviews: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch reviews: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> updateReview(
    String reviewId,
    double rating,
    String comment,
  ) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiEndpoints.updateReview}$reviewId',
        data: {'rating': rating, 'comment': comment},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update review: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update review: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      final response = await _apiService.dio.delete(
        '${ApiEndpoints.deleteReview}$reviewId',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete review: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete review: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
