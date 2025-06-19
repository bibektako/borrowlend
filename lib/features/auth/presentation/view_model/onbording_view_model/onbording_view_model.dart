import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view/signup_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_event.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_state.dart';
import 'package:borrowlend/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnbordingViewModel extends Bloc<OnbordingEvent, OnbordingState> {
  OnbordingViewModel() : super(OnbordingState.initial()) {
    on<NavigateToSignupView>(_onNavigateToSignupView);
    on<NavigateToLoginView>(_onNavigateToLoginView);
  }

  void _onNavigateToSignupView(
    NavigateToSignupView event,
    Emitter<OnbordingState> emit,
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

  void _onNavigateToLoginView(
    NavigateToLoginView event,
    Emitter<OnbordingState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
    }
  }
}
