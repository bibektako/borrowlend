// import 'package:borrowlend/app/use_case/usecase.dart';
// import 'package:borrowlend/core/error/failure.dart';
// import 'package:borrowlend/features/profile/domain/entity/user_profile_entity.dart';
// import 'package:borrowlend/features/profile/domain/repository/profile_repository.dart';
// import 'package:dartz/dartz.dart';

// /// Use case for updating the user's profile data.
// ///
// /// This class handles the business logic of taking a user profile object
// /// and passing it to the repository to be updated.
// class UpdateProfileUseCase implements Usecase<void, UserProfileEntity> {
//   final IProfileRepository _repository;

//   UpdateProfileUseCase(this._repository);

//   /// Executes the use case.
//   ///
//   /// Takes a [UserProfileEntity] object as parameters and passes it to the
//   /// repository's updateProfile method. Returns either a [Failure] or `void`.
//   @override
//   Future<Either<Failure, void>> call(UserProfileEntity params) async {
//     return await _repository.updateProfile(params);
//   }
// }