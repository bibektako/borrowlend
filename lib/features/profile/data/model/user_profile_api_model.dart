import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_api_model.g.dart';
@JsonSerializable()
class UserProfileModel {
  @JsonKey(name: '_id')
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? location;
  final String? bio;

  UserProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.location,
    this.bio,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileEntity toEntity() {
    return UserProfileEntity(
      id: id,
      username: username,
      email: email,
      phone: phone,
      location: location,
      bio: bio,
    );
  }
}