import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/items/data/data_source/bookmark_datasource.dart';
import 'package:borrowlend/features/items/data/model/item_api_model.dart';
import 'package:dio/dio.dart';


class BookmarkRemoteDataSource implements IBookmarkDataSource {
  final ApiService _apiService;

  BookmarkRemoteDataSource(this._apiService);

  @override
  Future<void> addBookmark(String itemId) async {
    try {
      await _apiService.dio.post('${ApiEndpoints.bookmarks}/$itemId');
    } on DioException catch (e) {
      throw Exception(
        'Failed to add bookmark: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

  @override
  Future<void> removeBookmark(String itemId) async {
    try {
      await _apiService.dio.delete('${ApiEndpoints.bookmarks}/$itemId');
    } on DioException catch (e) {
      throw Exception(
        'Failed to remove bookmark: ${e.response?.data['message'] ?? e.message}',
      );
    }
  }

 @override
Future<List<ItemApiModel>> getBookmarkedItems() async {
  try {
    final response = await _apiService.dio.get(ApiEndpoints.bookmarks);


    final List<dynamic> data = response.data['data'];

    final List<ItemApiModel> validModels = [];
    for (final itemJson in data) {
      if (itemJson is Map<String, dynamic>) {
        validModels.add(ItemApiModel.fromJson(itemJson));
      } 
    }
    return validModels;

  } on DioException catch (e) {
    throw Exception('Failed to get bookmarks: ${e.response?.data['message'] ?? e.message}');
  }
}
}
