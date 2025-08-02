import 'package:borrowlend/features/notification/domain/entity/notification_user_entity.dart';
import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final NotificationUserEntity sender;
  final String type;
  final String message;
  final bool isRead;
  final String? link;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.sender,
    required this.type,
    required this.message,
    required this.createdAt,
    this.link,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, sender, type, message, isRead, link, createdAt];
}