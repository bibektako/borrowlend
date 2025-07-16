// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_items_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllItemsDto _$GetAllItemsDtoFromJson(Map<String, dynamic> json) =>
    GetAllItemsDto(
      success: json['success'] as bool,
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => ItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllItemsDtoToJson(GetAllItemsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
