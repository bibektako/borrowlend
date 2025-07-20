// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemApiModel _$ItemApiModelFromJson(Map<String, dynamic> json) => ItemApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      borrowingPrice: (json['borrowingPrice'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      numReviews: (json['numReviews'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : OwnerApiModel.fromJson(json['owner'] as Map<String, dynamic>),
      category: json['category'] == null
          ? null
          : CategoryApiModel.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemApiModelToJson(ItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrls': instance.imageUrls,
      'borrowingPrice': instance.borrowingPrice,
      'rating': instance.rating,
      'numReviews': instance.numReviews,
      'owner': instance.owner?.toJson(),
      'category': instance.category?.toJson(),
    };

OwnerApiModel _$OwnerApiModelFromJson(Map<String, dynamic> json) =>
    OwnerApiModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$OwnerApiModelToJson(OwnerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'location': instance.location,
    };

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
    };
