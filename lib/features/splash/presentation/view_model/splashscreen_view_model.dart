import 'package:borrowlend/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/features/auth/presentation/view/onboarding_view.dart';
import 'package:borrowlend/features/home/presentation/view/home_page_view.dart';

// You can use Cubit or Bloc, the logic is the same. Cubit is often simpler for splash screens.
class SplashscreenViewModel extends Cubit<bool> {
  // 1. Add the dependency
  final TokenSharedPrefs _tokenSharedPrefs;

  // 2. Update the constructor to accept the dependency
  SplashscreenViewModel({required TokenSharedPrefs tokenSharedPrefs})
    : _tokenSharedPrefs = tokenSharedPrefs,
      super(false);

  // This is the method that your view is trying to call.
  Future<void> init(BuildContext context) async {
    // Wait for a moment to display your logo
    await Future.delayed(const Duration(seconds: 2));

    // Check if a token exists
    final tokenResult = await _tokenSharedPrefs.getToken();

    // Navigate based on the result
    tokenResult.fold(
      (failure) {
        // NO TOKEN FOUND: Go to your onboarding/login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingView()),
        );
      },
      (token) {
        if (token != null && token.isNotEmpty) {
          // TOKEN FOUND: User is logged in. Go to the Home Page.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardView()),
          );
        } else {
          // NO TOKEN FOUND: Go to your onboarding/login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnBoardingView()),
          );
        }
      },
    );
  }
}
