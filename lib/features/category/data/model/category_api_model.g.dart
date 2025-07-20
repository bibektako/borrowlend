// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      categoryId: json['_id'] as String,
      category: json['name'] as String,
      category_image: json['imageUrl'] as String,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      '_id': instance.categoryId,
      'name': instance.category,
      'imageUrl': instance.category_image,
    };
