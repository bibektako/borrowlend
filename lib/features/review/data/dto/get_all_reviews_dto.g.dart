// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_reviews_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllReviewsDto _$GetAllReviewsDtoFromJson(Map<String, dynamic> json) =>
    GetAllReviewsDto(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => ReviewApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllReviewsDtoToJson(GetAllReviewsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };
