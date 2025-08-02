

import 'dart:async';

import 'package:borrowlend/features/auth/presentation/view_model/session/auth_status.dart';
import 'package:borrowlend/features/auth/presentation/view_model/session/session_cubit.dart';
import 'package:borrowlend/features/notification/domain/entity/notification_entity.dart';
import 'package:borrowlend/features/notification/domain/use_case/connect_socket_usecase.dart';
import 'package:borrowlend/features/notification/domain/use_case/get_notification_usecase.dart';
import 'package:borrowlend/features/notification/domain/use_case/listen_notification_usecase.dart';
import 'package:flutter/material.dart';

class NotificationViewModel extends ChangeNotifier {
  final GetNotificationsUseCase getNotificationsUseCase;
  final ListenToNotificationsUseCase listenToNotificationsUseCase;
  final ConnectSocketUseCase connectSocketUseCase;
  final SessionCubit sessionCubit;

  StreamSubscription? _notificationSubscription;

  NotificationViewModel({
    required this.getNotificationsUseCase,
    required this.listenToNotificationsUseCase,
    required this.connectSocketUseCase,
    required this.sessionCubit,
  });

  List<NotificationEntity> _notifications = [];
  List<NotificationEntity> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void initialize() {
    // 1. Get the current state from the SessionCubit. Its type is SessionState.
    final sessionState = sessionCubit.state;

    // 2. THIS IS THE FIX: Check the `status` property of the state object.
    //    Also check that the user object is not null for full type safety.
    if (sessionState.status == AuthStatus.authenticated && sessionState.user != null) {
      
      // 3. We can now safely access the user's ID.
      //    The `!` is safe here because of the null check above.
      final String currentUserId = sessionState.user!.userId!;
      
      // 4. Proceed with initialization as before.
      connectSocketUseCase(currentUserId);
      fetchNotifications();
      _listenForNewNotifications();
    } else {
      // If the status is unauthenticated, do nothing.
      print("NotificationViewModel: User is not authenticated. Skipping initialization.");
    }
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notifications = await getNotificationsUseCase();
    } catch (e) {
      print("Error fetching notifications: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  void _listenForNewNotifications() {
    _notificationSubscription?.cancel();
    _notificationSubscription = listenToNotificationsUseCase().listen((notification) {
      _notifications.insert(0, notification);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }
}