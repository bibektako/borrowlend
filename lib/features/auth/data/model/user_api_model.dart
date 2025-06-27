import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String? username;
  final String? phone;
  final String? email;
  final String? password;
  final String? bio;
  final String? location;

  const UserApiModel({
    this.userId,
    this.username,
    this.phone,
    this.email,
    this.password,
    this.bio,
    this.location,
  });

  // Correctly named factory constructor
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  // Convert this API Model to a Domain Entity
  UserEntity toEntity() {
    return UserEntity(
      username: username ?? '',
      email: email ?? '',
      phone: phone ?? '',
      password: password ?? '',
    );
  }

  // Create an API Model from a Domain Entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      username: entity.username,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props => [userId, username, phone, email, password];
}
