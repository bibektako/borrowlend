// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewUserApiModel _$ReviewUserApiModelFromJson(Map<String, dynamic> json) =>
    ReviewUserApiModel(
      id: json['_id'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$ReviewUserApiModelToJson(ReviewUserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
    };

ReviewApiModel _$ReviewApiModelFromJson(Map<String, dynamic> json) =>
    ReviewApiModel(
      id: json['_id'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      itemId: json['item_id'] as String,
      user:
          ReviewUserApiModel.fromJson(json['user_id'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReviewApiModelToJson(ReviewApiModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'rating': instance.rating,
      'comment': instance.comment,
      'item_id': instance.itemId,
      'user_id': _userToJson(instance.user),
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
    };
