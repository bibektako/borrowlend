import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/notification/data/dto/notification_dto.dart';

class NotificationApiDataSource {
  final ApiService _apiService;

  NotificationApiDataSource(this._apiService);

  Future<List<NotificationDto>> getNotifications() async {
    try {
      final response = await _apiService.dio.get('/notifications');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => NotificationDto.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }
}