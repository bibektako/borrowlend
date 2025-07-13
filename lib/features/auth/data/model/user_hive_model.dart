import 'package:borrowlend/app/constant/hive_table_constant.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:uuid/uuid.dart';
//Adapter
part 'user_hive_model.g.dart';
@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String password;
  @HiveField(5)
  final String? location;
  @HiveField(6)
  final String? bio;

  UserHiveModel({
    String? userId,
    required this.email,
    required this.username,
    required this.phone,
    required this.password,
    this.bio,
    this.location,
  }) : userId =
           userId ??
           Uuid()
               .v4(); // is user id is not available generate it automatically through uuid version 4 && if given use given userId

  const UserHiveModel.initial() // creating a initial value
    : userId = '',
      username = '',
      email = '',
      phone = '',
      password = '',
      bio = '',
      location = '';

  //From entity
  factory UserHiveModel.fromEntity(UserEntity user){
    return UserHiveModel(userId: user.userId, 
      username: user.username,
      email: user.email,
      phone: user.phone,
      password: user.password, 
      location: user.location,
      bio: user.bio,);
  }

  // To Entity
  UserEntity toEntity(){
    return UserEntity(  userId: userId,
      username: username,
      email: email,
      phone: phone,
      password: password,
      location: location,
      bio: bio,);
  }

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    phone,
    password,
    bio,
    location,
  ];
}
