import 'package:borrowlend/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final UserEntity? user;

  LoginState({required this.isLoading, required this.isSuccess, this.user});
  LoginState.initial() : isLoading = false, isSuccess = false, user= null;


  LoginState copyWith({bool? isLoading, bool? isSuccess, UserEntity? user}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      user: user ?? this.user
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, user];
}


