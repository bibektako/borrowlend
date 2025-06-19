import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:borrowlend/features/auth/presentation/view/onboarding_view.dart';
import 'package:borrowlend/features/auth/presentation/view_model/onbording_view_model/onbording_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashscreenViewModel extends Cubit<void> {
  SplashscreenViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<OnbordingViewModel>(),
                child: OnBoardingView(),
              ),
        ),
      );
    }
  }
}
