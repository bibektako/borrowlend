// lib/core/utils/logout_helper.dart
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:flutter/material.dart';

Future<void> handleLogout(BuildContext context) async {
  final tokenManager = serviceLocator<TokenSharedPrefs>();
  final result = await tokenManager.deleteToken();

  result.fold(
    (failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${failure.message}'),
          backgroundColor: Colors.red,
        ),
      );
    },
    (_) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    },
  );
}
