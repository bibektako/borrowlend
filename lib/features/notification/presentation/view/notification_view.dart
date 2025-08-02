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
    // Use WidgetsBinding.instance.addPostFrameCallback to ensure that the
    // context is available when we access the provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This simple, parameter-less call is all that's needed.
      // The ViewModel is now entirely responsible for getting the
      // current user's ID from the SessionCubit.
      // 'listen: false' is crucial because we are only dispatching an action,
      // not listening to state changes within initState.
      Provider.of<NotificationViewModel>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: false, // Or true, based on your app's style
      ),
      // The Consumer widget is the most efficient way to listen to a provider.
      // It ensures that only this part of the widget tree rebuilds when
      // the ViewModel calls notifyListeners().
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          // --- 1. Loading State ---
          // Show a loading spinner, but only on the initial load when the list is empty.
          // This prevents the spinner from showing over existing data during a refresh.
          if (viewModel.isLoading && viewModel.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- 2. Empty State ---
          // If loading is finished and there are still no notifications, show a helpful message.
          if (viewModel.notifications.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "You have no notifications yet.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // --- 3. Data State ---
          // Display the list of notifications. The RefreshIndicator allows for pull-to-refresh.
          return RefreshIndicator(
            onRefresh: () => viewModel.fetchNotifications(),
            child: ListView.builder(
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                // Get the specific notification entity for this list item
                final notification = viewModel.notifications[index];
                return ListTile(
                  leading: Icon(
                    notification.isRead
                        ? Icons.mark_email_read_outlined
                        : Icons.mark_email_unread_sharp,
                    color: notification.isRead
                        ? Colors.grey.shade600
                        : Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                  title: Text(
                    notification.message,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "From: ${notification.sender.username} • ${notification.type.replaceAll('_', ' ')}",
                  ),
                  onTap: () {
                    // TODO: Implement navigation to the notification's link, e.g.:
                    // if (notification.link != null) {
                    //   Navigator.pushNamed(context, notification.link!);
                    // }
                    // TODO: Or implement a "mark as read" feature, e.g.:
                    // viewModel.markAsRead(notification.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}