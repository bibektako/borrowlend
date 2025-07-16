import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:borrowlend/features/splash/presentation/view_model/splashscreen_view_model.dart';

// This code is already correct and does not need changes.
class SplashscreenView extends StatelessWidget {
  const SplashscreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // This safely calls the init method after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashscreenViewModel>().init(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 20), // Added some space
                const CircularProgressIndicator(color: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}