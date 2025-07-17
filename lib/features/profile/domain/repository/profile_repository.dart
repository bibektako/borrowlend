import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IProfileRepository {
  
  Future<Either<Failure, UserProfileEntity>> getProfile();

  Future<Either<Failure, void>> updateProfile(UserProfileEntity profile);
}