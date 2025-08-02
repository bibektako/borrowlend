import 'package:borrowlend/features/notification/domain/entity/notification_entity.dart';
import 'package:borrowlend/features/notification/domain/repository/notification_repository.dart';

class ListenToNotificationsUseCase {
  final NotificationRepository repository;
  ListenToNotificationsUseCase(this.repository);
  Stream<NotificationEntity> call() => repository.getNewNotificationStream();
}
