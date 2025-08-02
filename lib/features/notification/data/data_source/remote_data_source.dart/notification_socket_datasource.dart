import 'dart:async';
import 'package:borrowlend/app/constant/api_endpoints.dart';
import 'package:borrowlend/features/notification/data/dto/notification_dto.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class NotificationSocketDataSource {
  late IO.Socket _socket;
  final _controller = StreamController<NotificationDto>.broadcast();

  Stream<NotificationDto> get notificationStream => _controller.stream;

  void connect(String userId) {
    _socket = IO.io(
        ApiEndpoints.serverAddress,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    _socket.connect();
    _socket.onConnect((_) => _socket.emit('addNewUser', userId));
    _socket.on('newNotification', (data) => _controller.add(NotificationDto.fromJson(data)));
  }

  void disconnect() {
    _socket.disconnect();
  }
}