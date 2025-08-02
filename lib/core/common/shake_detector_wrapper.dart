import 'dart:async';
import 'dart:math';

import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GlobalShakeDetector {
  static final GlobalShakeDetector _instance = GlobalShakeDetector._internal();
  factory GlobalShakeDetector() => _instance;
  GlobalShakeDetector._internal();

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime _lastShakeTime = DateTime.now();

  static const double shakeThreshold = 15.0;
  static const Duration debounceDuration = Duration(seconds: 2);

  void start(BuildContext context) {
    _subscription ??= accelerometerEvents.listen((event) {
      final gX = event.x / 9.81;
      final gY = event.y / 9.81;
      final gZ = event.z / 9.81;

      final gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThreshold) {
        print("📱 Shake detected!");
        final now = DateTime.now();
        if (now.difference(_lastShakeTime) > debounceDuration) {
          _lastShakeTime = now;
          _showLogoutConfirmation(context);
        }
      }
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text("Do you want to log out?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop(); // close dialog first

                  final tokenSharedPrefs = serviceLocator<TokenSharedPrefs>();
                  await tokenSharedPrefs.deleteToken();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginView()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
