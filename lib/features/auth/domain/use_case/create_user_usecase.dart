import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateUserUsecaseParams extends Equatable {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String? location;
  final String? bio;

  const CreateUserUsecaseParams({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    this.location,
    this.bio,
  });

  const CreateUserUsecaseParams.initial()
    : username = '',
      email = '',
      phone = '',
      password = '',
      location = '',
      bio = '';

  @override
  List<Object?> get props => [username, email, phone, password, location, bio];
}

// usecase with params

class CreateUserUsecase
    implements UsecaseWithParams<void, CreateUserUsecaseParams> {
  final IUserRepository _userRepository;

  CreateUserUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(CreateUserUsecaseParams params) {
    //converting to entity
    final user = UserEntity(
      username: params.username,
      email: params.email,
      phone: params.phone,
      password: params.password,
      location: params.location,
      bio: params.bio,
    );

    // call the repository to register the student
    return _userRepository.createUser(user);
  }
}
