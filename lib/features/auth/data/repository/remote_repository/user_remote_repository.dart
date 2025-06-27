import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDatasource})
    : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, void>> createUser(UserEntity user) async {
    // TODO: implement createUser
    try {
      await _userRemoteDatasource.createUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async{
   try {
     final token = await _userRemoteDatasource.loginUser(email, password);
     return Right(token);
   } catch (e) {
     return Left(RemoteDatabaseFailure(message: e.toString()));
   }
  }
}
