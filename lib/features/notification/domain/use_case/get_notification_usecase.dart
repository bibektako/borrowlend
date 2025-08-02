import 'package:borrowlend/features/notification/domain/entity/notification_entity.dart';
import 'package:borrowlend/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);
  Future<List<NotificationEntity>> call() => repository.getNotifications();
}