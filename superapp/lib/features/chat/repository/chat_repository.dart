import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';
import '../services/chat_api_service.dart';

class ChatRepository {
  final ChatApiService _apiService;

  ChatRepository({ChatApiService? apiService})
      : _apiService = apiService ?? ChatApiService();

  Future<ChatListResponse> getChats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return await _apiService.getChats(token);
  }

  Future<ConversationResponse> getConversation(int conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return await _apiService.getConversation(token, conversationId);
  }

  Future<SendMessageResponse> sendMessage({
    required int receiverId,
    required String message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return await _apiService.sendMessage(
      token,
      receiverId: receiverId,
      message: message,
    );
  }

  Future<bool> markAsRead(int conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      return false;
    }

    return await _apiService.markAsRead(token, conversationId);
  }
}
