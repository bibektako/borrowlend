// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'location': instance.location,
      'bio': instance.bio,
    };
