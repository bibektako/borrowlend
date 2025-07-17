import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
import 'package:borrowlend/features/profile/domain/repository/profile_repository.dart';
import 'package:dartz/dartz.dart';
class GetProfileUseCase implements UsecaseWithoutParams<UserProfileEntity> {
  final IProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call() async {
    return await _repository.getProfile();
  }
}