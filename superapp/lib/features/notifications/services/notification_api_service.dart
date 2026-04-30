import 'package:dio/dio.dart';
import 'package:superapp/core/services/api_service.dart';
import 'package:superapp/features/notifications/models/notification_model.dart';

class NotificationApiService {
  Future<NotificationResponse> getNotifications(String token, {bool unreadOnly = false}) async {
    try {
      final endpoint = unreadOnly ? '/api/notifications/unread' : '/api/notifications';
      final response = await apiService.get(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return NotificationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markAsRead(String token, String notificationId) async {
    try {
      final response = await apiService.post(
        '/api/notifications/$notificationId/mark-read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['success'] ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteNotification(String token, String notificationId) async {
    try {
      final response = await apiService.delete(
        '/api/notifications/$notificationId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['success'] ?? false;
    } catch (e) {
      return false;
    }
  }
}
