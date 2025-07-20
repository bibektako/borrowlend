import 'dart:io';

import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/items/data/data_source/item_datasource.dart';
import 'package:borrowlend/features/items/domain/entity/item_entity.dart';
import 'package:borrowlend/features/items/domain/repository/item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ItemRemoteRepository implements IItemRepository {
  final IItemDataSource _itemRemoteDatasource;

  ItemRemoteRepository({required IItemDataSource itemRemoteDatasource})
      : _itemRemoteDatasource = itemRemoteDatasource;

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    try {
      final itemModels = await _itemRemoteDatasource.getAllItems();
      final itemEntities = itemModels.map((model) => model.toEntity()).toList();
      return Right(itemEntities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createItem(ItemEntity item) async {
    try {
      final formData = await _createFormData(item);
      await _itemRemoteDatasource.createItem(formData);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateItem(ItemEntity item) async {
    try {
      if (item.id == null) {
        return Left(RemoteDatabaseFailure(message: "Item ID is missing for update."));
      }
      final formData = await _createFormData(item);
      await _itemRemoteDatasource.updateItem(item.id!, formData);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItem(String id) async {
    try {
      await _itemRemoteDatasource.deleteItem(id);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  Future<FormData> _createFormData(ItemEntity item) async {
    Map<String, dynamic> map = {
      'name': item.name,
      'description': item.description,
      'borrowingPrice': item.borrowingPrice.toString(),
      'category': item.category.categoryId,
    };
    
    if (item.imageUrls.isNotEmpty) {
      final imageFiles = <MultipartFile>[];
      for (String path in item.imageUrls) {
        final file = File(path);
        if (await file.exists()) {
          imageFiles.add(await MultipartFile.fromFile(path, filename: path.split('/').last));
        }
      }
      
      if (imageFiles.isNotEmpty) {
        map['imageUrls'] = imageFiles;
      }
    }
    
    return FormData.fromMap(map);
  }
  
  @override
  Future<Either<Failure, List<ItemEntity>>> getMyItems() async{
     try {
    final itemModels = await _itemRemoteDatasource.getMyItems();
    final itemEntities = itemModels.map((model) => model.toEntity()).toList();
    return Right(itemEntities);
  } catch (e) {
    return Left(RemoteDatabaseFailure(message: e.toString()));
  }
  }
}