import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/items/data/data_source/item_datasource.dart';
import 'package:borrowlend/features/items/data/dto/get_all_items_dto.dart';
import 'package:borrowlend/features/items/data/model/item_api_model.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:dio/dio.dart';

class ItemRemoteDataSource implements IItemDataSource {
  final ApiService _apiService;

  ItemRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<ItemApiModel>> getAllItems() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.items);

      if (response.statusCode == 200) {
        final getAllItemsDto = GetAllItemsDto.fromJson(response.data);

        return getAllItemsDto.data;
      } else {
        throw Exception('Failed to get items: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(
        'Failed to get items: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<void> createItem(FormData formData) async {
    try {
      await _apiService.dio.post(
        ApiEndpoints.items, // Your backend route is POST /api/items
        data: formData,
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to create item: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<void> updateItem(String itemId, FormData formData) async {
    try {
      await _apiService.dio.put(
        '${ApiEndpoints.items}/$itemId',
        data: formData,
      );
    } on DioException catch (e) {
      throw Exception(
        'Failed to update item: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    try {
      await _apiService.dio.delete('${ApiEndpoints.items}/$itemId');
    } on DioException catch (e) {
      throw Exception(
        'Failed to delete item: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }
  
  @override
  Future<List<ItemApiModel>> getMyItems() async{
   try {
    final response = await _apiService.dio.get(ApiEndpoints.getMyItems);
    final List<dynamic> data = response.data['data'];
    return data.map((itemJson) => ItemApiModel.fromJson(itemJson)).toList();
  } on DioException catch (e) {
    throw Exception('Failed to get your items: ${e.response?.data['message'] ?? e.message}');
  }
  }
}
