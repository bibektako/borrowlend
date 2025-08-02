import 'package:borrowlend/core/network/api_service.dart';
import 'package:borrowlend/features/notification/data/dto/notification_dto.dart';

import 'package:dio/dio.dart'; // Import Dio if not already imported

class NotificationApiDataSource {
  final ApiService _apiService;

  NotificationApiDataSource(this._apiService);

  Future<List<NotificationDto>> getNotifications() async {
    try {
      final Response response = await _apiService.dio.get('/notifications');

      final List<dynamic> responseData = response.data as List<dynamic>;

      return responseData.map((json) => NotificationDto.fromJson(json as Map<String, dynamic>)).toList();

    } on DioException catch (e) {
      print("DioException fetching notifications: $e");
      throw Exception('Failed to load notifications: Network error');
    } catch (e) {
      print("Parsing error fetching notifications: $e");
      throw Exception('Failed to load notifications: Data parsing failed');
    }
  }
}