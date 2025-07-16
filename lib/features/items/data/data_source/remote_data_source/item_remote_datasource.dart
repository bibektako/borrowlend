import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/items/data/dto/get_all_items_dto.dart';
import 'package:borrowlend/features/items/data/model/item_api_model.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:dio/dio.dart';

class ItemRemoteDatasource {
  final ApiService _apiService;

  ItemRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  Future<List<ItemEntity>> getAllItems() async {
    try {
      // Assuming your ApiEndpoints file has a 'getAllItems' constant
      final response = await _apiService.dio.get(ApiEndpoints.getAllItems);

      if (response.statusCode == 200) {
        final getAllItemsDto = GetAllItemsDto.fromJson(response.data);
        // Convert the list of ItemApiModels to a list of ItemEntities
        return ItemApiModel.toEntityList(getAllItemsDto.data);
      } else {
        throw Exception('Failed to get items: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get items: $e');
    }
  }

  // Future<void> createItem(ItemEntity item) async {
  //   try {
  //     final itemApiModel = ItemApiModel.fromEntity(item);
  //     // Assuming your ApiEndpoints file has a 'createItem' constant
  //     await _apiService.dio.post(
  //       ApiEndpoints.createItem,
  //       data: itemApiModel.toJson(),
  //     );
  //   } on DioException catch (e) {
  //     throw Exception('Failed to create item: $e');
  //   }
  // }

  // Future<void> updateItem(ItemEntity item) async {
  //   try {
  //     final itemApiModel = ItemApiModel.fromEntity(item);
  //     // Backend expects: /items/:id
  //     await _apiService.dio.patch( // Or PUT, depending on your API design
  //       '${ApiEndpoints.updateItem}/${item.id}',
  //       data: itemApiModel.toJson(),
  //     );
  //   } on DioException catch (e) {
  //     throw Exception('Failed to update item: $e');
  //   }
  // }

  // Future<void> deleteItem(String id) async {
  //   try {
  //     // Backend expects: /items/:id
  //     // Your ApiService should handle adding the Authorization header
  //     await _apiService.dio.delete('${ApiEndpoints.deleteItem}/$id');
  //   } on DioException catch (e) {
  //     throw Exception('Failed to delete item: $e');
  //   }
  // }
}