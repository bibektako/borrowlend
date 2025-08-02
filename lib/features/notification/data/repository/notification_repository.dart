

import 'package:borrowlend/features/notification/data/data_source/remote_data_source.dart/notification_api_datasource.dart';
import 'package:borrowlend/features/notification/data/data_source/remote_data_source.dart/notification_socket_datasource.dart';
import 'package:borrowlend/features/notification/domain/entity/notification_entity.dart';
import 'package:borrowlend/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApiDataSource apiDataSource;
  final NotificationSocketDataSource socketDataSource;

  NotificationRepositoryImpl({ required this.apiDataSource, required this.socketDataSource });

  @override
  void connectToNotificationSocket(String userId) => socketDataSource.connect(userId);

  @override
  void disconnectFromNotificationSocket() => socketDataSource.disconnect();

  @override
  Stream<NotificationEntity> getNewNotificationStream() {
    return socketDataSource.notificationStream.map((dto) => dto.toEntity());
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final dtos = await apiDataSource.getNotifications();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}