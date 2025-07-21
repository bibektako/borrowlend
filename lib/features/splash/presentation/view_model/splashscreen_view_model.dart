import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:borrowlend/features/auth/presentation/view/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashscreenViewModel extends Cubit<bool> {
  final TokenSharedPrefs _tokenSharedPrefs;
  final ApiService _apiService; 

  SplashscreenViewModel({
    required TokenSharedPrefs tokenSharedPrefs,
    required ApiService apiService, 
  })  : _tokenSharedPrefs = tokenSharedPrefs,
        _apiService = apiService,
        super(false);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final tokenResult = await _tokenSharedPrefs.getToken();

    tokenResult.fold(
      (failure) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnBoardingView()),
        );
      },
      (token) {
        if (token != null && token.isNotEmpty) {
          _apiService.setAuthToken(token); 
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardView()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnBoardingView()),
          );
        }
      },
    );
  }
}
