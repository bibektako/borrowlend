import '../entity/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  void connectToNotificationSocket(String userId);
  Stream<NotificationEntity> getNewNotificationStream();
  void disconnectFromNotificationSocket();
}