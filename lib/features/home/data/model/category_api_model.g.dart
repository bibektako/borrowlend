// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../category/data/model/category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      categoryId: json['_id'] as String?,
      category: json['category'] as String,
      category_image: json['category_image'] as String,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      '_id': instance.categoryId,
      'category': instance.category,
      'category_image': instance.category_image,
    };
