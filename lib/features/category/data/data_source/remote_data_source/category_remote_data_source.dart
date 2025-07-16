import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/category/data/data_source/category_data_source.dart';
import 'package:borrowlend/features/category/data/dto/category_dto.dart';
import 'package:borrowlend/features/category/data/model/category_api_model.dart';
import 'package:dio/dio.dart';

class CategoryRemoteDataSource implements ICategoryDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSource({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<CategoryApiModel>> getCategory() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllCategory);

      if (response.statusCode == 200) {
        CategoryDto categoryDto = CategoryDto.fromJson(response.data);
        return categoryDto.data;
      } else {
        throw Exception('Failed to fetch categories: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}