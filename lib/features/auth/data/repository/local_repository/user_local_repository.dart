import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserLocalRepository  implements IUserRepository{
  final UserLocalDatasource _userLocalDatasource;
  UserLocalRepository ({ required UserLocalDatasource userLocalDatasource})
  : _userLocalDatasource = userLocalDatasource;
  @override
  Future<Either<Failure, void>> createUser(UserEntity user) async {
    try {
      await _userLocalDatasource.createUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
    
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      await _userLocalDatasource.deleteUser(userId);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, (UserEntity, String)>> loginUser(
      String email, String password) async {
    throw UnimplementedError(
        'Login is a remote operation and is not supported by the local repository.');
  }
  
  @override
  Future<Either<Failure, void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

}