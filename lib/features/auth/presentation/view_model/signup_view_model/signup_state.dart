import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
  });

  const SignupState.initial()
  :isLoading = false,
   isSuccess = false, 
   errorMessage = null;
  

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage];
}
