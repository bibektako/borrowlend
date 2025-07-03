import 'dart:async';

import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';
import 'package:borrowlend/features/auth/presentation/view/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashscreenView extends StatelessWidget {
  const SplashscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashscreenViewModel>().init(context);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo/applogo.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                CircularProgressIndicator(color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
