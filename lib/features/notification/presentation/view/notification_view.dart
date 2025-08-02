import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationViewModel>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: false),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "You have no notifications yet.",
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = viewModel.notifications[index];
                final isRead = notification.isRead;

                return Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color:
                      isRead
                          ? theme.cardColor
                          : colorScheme.primary.withOpacity(0.06),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          isRead
                              ? Colors.grey[200]
                              : colorScheme.primary.withOpacity(0.15),
                      child: Icon(
                        isRead
                            ? Icons.mark_email_read_outlined
                            : Icons.mark_email_unread_sharp,
                        color: isRead ? Colors.grey[600] : colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      notification.message,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "From: ${notification.sender.username} • ${notification.type.replaceAll('_', ' ')}",
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
