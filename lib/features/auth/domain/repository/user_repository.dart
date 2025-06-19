
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository{
  Future<Either<Failure,void>> createUser(UserEntity user);
  Future<Either<Failure,String>> loginUser( String email, String password);
  Future<Either<Failure, String>> getCurrentUser();
  Future<Either<Failure,void>> deleteUser(String userId);
}
