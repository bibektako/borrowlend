import 'package:borrowlend/features/notification/domain/repository/notification_repository.dart';

class ConnectSocketUseCase {
  final NotificationRepository repository;
  ConnectSocketUseCase(this.repository);
  void call(String userId) => repository.connectToNotificationSocket(userId);
}