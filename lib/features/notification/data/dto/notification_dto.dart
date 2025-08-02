import 'package:borrowlend/features/notification/domain/entity/notification_entity.dart';
import 'package:borrowlend/features/notification/domain/entity/notification_user_entity.dart';

class NotificationDto {
  final String id;
  final NotificationUserDto sender;
  final String type;
  final String message;
  final bool isRead;
  final String? link;
  final String createdAt;

  NotificationDto({
    required this.id,
    required this.sender,
    required this.type,
    required this.message,
    required this.isRead,
    this.link,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationDto(
        id: json['_id'],
        sender: NotificationUserDto.fromJson(json['sender']),
        type: json['type'],
        message: json['message'],
        isRead: json['read'] ?? false,
        link: json['link'],
        createdAt: json['createdAt'],
      );
    } catch (e) {
      print("Failed to parse NotificationDto. JSON data: $json, Error: $e");
      rethrow;
    }
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      sender: sender.toEntity(),
      type: type,
      message: message,
      isRead: isRead,
      link: link,
      createdAt: DateTime.parse(createdAt),
    );
  }
}

class NotificationUserDto {
  final String id;
  final String username;

  NotificationUserDto({required this.id, required this.username});

  factory NotificationUserDto.fromJson(Map<String, dynamic> json) {
    return NotificationUserDto(
      id: json['_id'],
      username: json['username'],
    );
  }

  NotificationUserEntity toEntity() {
    return NotificationUserEntity(
      id: id,
      username: username,
    );
  }
}