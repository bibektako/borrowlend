import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/app/use_case/usecase.dart';
import 'package:borrowlend/core/error/failure.dart';
import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:borrowlend/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUserUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUserUsecaseParams({required this.email, required this.password});

  const LoginUserUsecaseParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}

class LoginUserUsecase
    implements UsecaseWithParams<UserEntity, LoginUserUsecaseParams> {
  final IUserRepository _userRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  LoginUserUsecase({
    required IUserRepository userRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _userRepository = userRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, UserEntity>> call(LoginUserUsecaseParams params) async {
    final result = await _userRepository.loginUser(
      params.email,
      params.password,
    );
    return result.fold(
      (failure) => Left(failure),
      (successData) async {
        final user = successData.$1;
        final token = successData.$2;

        await _tokenSharedPrefs.saveToken(token);

        return Right(user);
      },
    );
    
    
  }
}
