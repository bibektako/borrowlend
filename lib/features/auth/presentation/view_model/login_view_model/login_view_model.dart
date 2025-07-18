import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view/forgot_password_view.dart';
import 'package:borrowlend/features/auth/presentation/view/signup_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:borrowlend/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final LoginUserUsecase _loginUsecase;
  LoginViewModel(this._loginUsecase) : super(LoginState.initial()) {
    on<NavigateToSignupView>(_onNavigateToSignupView);
    // on<NavigateToForgotPasswordView>(_onNavigateToForgotPasswordView);
    on<NavigateToHomeView>(_onNavigateToHomeView);
    on<LoginIntoSystemEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToSignupView(
    NavigateToSignupView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<SignupViewModel>(),
                child: SignupView(),
              ),
        ),
      );
    }
  }

  void _onNavigateToForgotPasswordView(
    NavigateToForgotPasswordView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => ForgotPasswordView()),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeView event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => DashboardView()),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginIntoSystemEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _loginUsecase(
      LoginUserUsecaseParams(email: event.email, password: event.password),
    );
    debugPrint(' debuggung testing' + result.toString());
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again and again.',
          color: Colors.red,
        );
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        add(
          NavigateToHomeView(
            context: event.context,
            destination: DashboardView(),
          ),
        );
      },
    );
  }
}
