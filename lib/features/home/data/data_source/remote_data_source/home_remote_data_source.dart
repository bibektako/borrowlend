import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/home/data/data_source/home_data_source.dart';
import 'package:borrowlend/features/home/data/dto/get_all_category_dto.dart';
import 'package:borrowlend/features/home/data/model/category_api_model.dart';
import 'package:borrowlend/features/home/domain/entity/category_entity.dart';
import 'package:dio/dio.dart';

class HomeRemoteDataSource implements IHomeDataSource {
  final ApiService _apiService;

  HomeRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<CategoryEntity>> getCategory() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getAllCategory);
      if (response.statusCode == 200) {
        GetAllCategoryDto getAllCategoryDto = GetAllCategoryDto.fromJson(
          response.data,
        );
        return CategoryApiModel.toEntityList(getAllCategoryDto.data);
      } else {
        throw Exception('Failed to fetch Category: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to Fetch Category: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
