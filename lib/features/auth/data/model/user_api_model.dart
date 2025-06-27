import 'dart:convert';

import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String username;
  final String phone;
  final String email;
  final String? password;
  final String? bio;
  final String? location;

  const UserApiModel({
    this.userId,
    required this.username,
    required this.phone,
    required this.email,
    required this.password,
    this.bio,
    this.location,
  });

  factory UserApiModel.formJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      username: username,
      email: email,
      phone: phone,
      password: password ?? '',
    );
  }

  factory UserApiModel.formEntity(UserEntity entity) {
    final user = UserApiModel(
      username: entity.username,
      phone: entity.phone,
      email: entity.email,
      password: entity.password,
    );
    return user;
  }

  @override
  List<Object?> get props => [userId, username, phone, email, password];
}
