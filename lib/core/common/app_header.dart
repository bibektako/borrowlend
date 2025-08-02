import 'package:borrowlend/app/service_locator/service_locator.dart';
import 'package:borrowlend/features/notification/presentation/view/notification_view.dart';
import 'package:borrowlend/features/notification/presentation/view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = Theme.of(context).iconTheme.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- App Logo ---
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/logo/applogo.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),

          // --- Notification Icon ---
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
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.surface,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: 26,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
