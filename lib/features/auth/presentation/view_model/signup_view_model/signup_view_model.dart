import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/auth/domain/use_case/create_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final CreateUserUsecase _createUserUsecase;

  SignupViewModel({required CreateUserUsecase createUserUsecase})
    : _createUserUsecase = createUserUsecase,
      super(SignupState.initial()) {
    on<SignupUserEvent>(_signupUserEvent);
    on<NavigateToLoginView>(_onNavigateToSignupView);
  }

  void _onNavigateToSignupView(
    NavigateToLoginView event,
    Emitter<SignupState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
        ),
      );
    }
  }

  Future<void> _signupUserEvent(
    SignupUserEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _createUserUsecase(
      CreateUserUsecaseParams(
        username: event.username,
        email: event.email,
        phone: event.phone,
        password: event.password,
      ),
    );
    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false,errorMessage: l.message));
        // showMySnackBar(
        //   context: event.context,
        //   message: l.message,
        //   color: Colors.red,
        // );
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        // showMySnackBar(
        //   context: event.context,
        //   message: "Registration Successful",
        // );
        // add(
        //   NavigateToLoginView(context: event.context, destination: LoginView()),
        // );
      },
    );
  }
}
