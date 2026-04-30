import 'package:dio/dio.dart';
import 'package:superapp/core/services/api_service.dart';
import '../models/chat_model.dart';

class ChatApiService {
  Future<ChatListResponse> getChats(String token) async {
    try {
      final response = await apiService.get(
        '/api/chats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ChatListResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ConversationResponse> getConversation(String token, int conversationId) async {
    try {
      final response = await apiService.get(
        '/api/chats/$conversationId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return ConversationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<SendMessageResponse> sendMessage(
    String token, {
    required int receiverId,
    required String message,
  }) async {
    try {
      final response = await apiService.post(
        '/api/chats/send',
        data: {
          'receiver_id': receiverId,
          'message': message,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return SendMessageResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> markAsRead(String token, int conversationId) async {
    try {
      // Assuming pattern matches notifications: /api/chats/{id}/mark-read
      final response = await apiService.post(
        '/api/chats/$conversationId/mark-read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['success'] ?? false;
    } catch (e) {
      // Fallback: If the endpoint doesn't exist, we still want the UI to function
      print("Warning: mark-read endpoint failed. Check if /api/chats/$conversationId/mark-read exists.");
      return false;
    }
  }
}
