import 'package:flutter/material.dart';

// 1. Import the necessary files
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/app/shared_pref/token_shared_prefs.dart';
import 'package:borrowlend/features/auth/presentation/view/login_view.dart'; // Your login screen

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo/applogo.png', width: 40, height: 40),

          GestureDetector(
            // 2. Make the onTap callback async
            onTap: () async {
              // 3. Get the TokenSharedPrefs instance from your service locator
              final tokenPrefs = serviceLocator<TokenSharedPrefs>();

              // 4. Call the method to delete the token
              await tokenPrefs.deleteToken();
              

              // 5. Navigate to the login screen and clear all previous routes
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => LoginView()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            child: const Icon(Icons.notifications_outlined, size: 28),
          ),
        ],
      ),
    );
  }
}
