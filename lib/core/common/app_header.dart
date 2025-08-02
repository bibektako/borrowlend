import 'package:borrowlend/features/notification/presentation/view/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Import the necessary files for the notification feature
import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/notification/presentation/view_model/notification_view_model.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChangeNotifierProvider(
                      create: (_) => serviceLocator<NotificationViewModel>(),
                      child: const NotificationScreen(),
                    );
                  },
                ),
              );
            },
            child: const Icon(Icons.notifications_outlined, size: 28),
          ),
        ],
      ),
    );
  }
}