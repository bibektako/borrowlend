import 'package:equatable/equatable.dart';

class NotificationUserEntity extends Equatable {
  final String id;
  final String username;

  const NotificationUserEntity({
    required this.id,
    required this.username,
  });

  @override
  List<Object?> get props => [id, username];
}