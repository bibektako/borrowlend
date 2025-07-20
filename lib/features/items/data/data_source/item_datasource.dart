
import 'package:borrowlend/features/items/data/model/item_api_model.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:dio/dio.dart'; 

abstract interface class IItemDataSource {
  Future<List<ItemApiModel>> getAllItems();
  
  Future< List<ItemApiModel>>getMyItems();

  
  Future<void> createItem(FormData formData); 
  
  Future<void> updateItem(String itemId, FormData formData);
  
  Future<void> deleteItem(String itemId);
}