import 'package:borrowlend/features/auth/data/model/user_api_model.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final String? userId;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String? location;
  final String? bio;
  

  const UserEntity({
    this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    this.location,
    this.bio,
  
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserApiModel.fromJson(json).toEntity();
  }

  Map<String, dynamic> toJson() {
    return UserApiModel.fromEntity(this).toJson();
  }


  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    phone,
    password,
    location,
    bio,
    
  ];

}