import 'package:shared_preferences/shared_preferences.dart';
import 'package:superapp/features/notifications/services/notification_api_service.dart';
import 'package:superapp/features/notifications/models/notification_model.dart';

class NotificationRepository {
  final NotificationApiService _apiService;

  NotificationRepository({NotificationApiService? apiService})
      : _apiService = apiService ?? NotificationApiService();

  Future<NotificationResponse> getNotifications({bool unreadOnly = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) throw Exception('No auth token found');
    return await _apiService.getNotifications(token, unreadOnly: unreadOnly);
  }

  Future<bool> markAsRead(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return false;
    return await _apiService.markAsRead(token, notificationId);
  }

  Future<bool> deleteNotification(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return false;
    return await _apiService.deleteNotification(token, notificationId);
  }
}
