import 'package:borrowlend/features/items/data/model/item_api_model.dart';

abstract interface class IBookmarkDataSource {
  Future<void> addBookmark(String itemId);
  Future<void> removeBookmark(String itemId);
  Future<List<ItemApiModel>> getBookmarkedItems();
}