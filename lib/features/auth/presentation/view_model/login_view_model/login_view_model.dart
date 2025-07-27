import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/core/common/snackbar/my_snackbar.dart';
import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/auth/domain/use_case/login_user_usecase.dart';
import 'package:borrowlend/features/auth/presentation/view/forgot_password_view.dart';
import 'package:borrowlend/features/auth/presentation/view/signup_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:borrowlend/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final LoginUserUsecase _loginUsecase;
  final SessionCubit _sessionCubit;

  LoginViewModel(this._loginUsecase, this._sessionCubit)
    : super(LoginState.initial()) {

    on<NavigateToSignupView>(_onNavigateToSignupView);
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
        MaterialPageRoute(builder: (_) => const DashboardView()),
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

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
      (response) {
        // response = custom model having token and userData (parsed from API)
        if (isClosed) return;

        // Set token in ApiService
        serviceLocator<ApiService>().setAuthToken(response.token);
        _sessionCubit.showSession(response.user);

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            user:
                response
                    .user, // assume this is the user data (from "data" field)
          ),
        );

        add(
          NavigateToHomeView(
            context: event.context,
            destination: const DashboardView(),
          ),
        );
      },
    );
  }
}
