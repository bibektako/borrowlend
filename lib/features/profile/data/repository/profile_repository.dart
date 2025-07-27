import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/profile/data/data_source/remote_data_source/profile_remote_datasource.dart';
import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:borrowlend/features/profile/domain/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile() async {
    try {
      final userProfileModel = await _remoteDataSource.getProfile();
      
      return Right(userProfileModel.toEntity());
      
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateProfile(UserProfileEntity profile) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, void>> updateProfile(UserProfileEntity profile) async {
  //   // try {
  //   //   final userProfileModel = UserProfileModel.fromEntity(profile);

  //   //   await _remoteDataSource.updateProfile(userProfileModel);
      
  //   //   return const Right(null);
      
  //   // } catch (e) {
  //   //   return Left(RemoteDatabaseFailure(message: e.toString()));
  //   // }
  // }
}