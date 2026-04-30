import 'dart:convert';

ChatListResponse chatListResponseFromJson(String str) => ChatListResponse.fromJson(json.decode(str));

String chatListResponseToJson(ChatListResponse data) => json.encode(data.toJson());

class ChatListResponse {
    bool success;
    List<ChatSession> data;

    ChatListResponse({
        required this.success,
        required this.data,
    });

    factory ChatListResponse.fromJson(Map<String, dynamic> json) {
        var dataJson = json["data"];
        List<ChatSession> sessions = [];
        
        if (dataJson is List) {
            sessions = dataJson.map((x) => ChatSession.fromJson(x)).toList();
        } else if (dataJson is Map) {
            // Handle pagination or associative maps
            var listData = dataJson["data"] ?? dataJson.values.toList();
            if (listData is List) {
                sessions = listData.map((x) => ChatSession.fromJson(x)).toList();
            }
        }
        
        return ChatListResponse(
            success: json["success"] ?? false,
            data: sessions,
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ChatSession {
    int id;
    int otherUserId;
    String otherUserName;
    String? otherUserProfileImage;
    String lastMessage;
    DateTime lastMessageTime;
    int unreadCount;

    ChatSession({
        required this.id,
        required this.otherUserId,
        required this.otherUserName,
        this.otherUserProfileImage,
        required this.lastMessage,
        required this.lastMessageTime,
        required this.unreadCount,
    });

    factory ChatSession.fromJson(Map<String, dynamic> json) {
        // Handle "other_user" object if present
        String name = "Unknown";
        String? profileImage;
        if (json["other_user"] != null && json["other_user"] is Map) {
            name = json["other_user"]["name"]?.toString() ?? "Unknown";
            profileImage = json["other_user"]["profile_image_url"]?.toString();
        } else {
            name = json["other_user_name"]?.toString() ?? "Unknown";
            profileImage = json["other_user_profile_image"]?.toString();
        }

        // Handle "last_message" being an object or a string
        String lastMsg = "";
        if (json["last_message"] != null) {
            if (json["last_message"] is Map) {
                lastMsg = json["last_message"]["message"]?.toString() ?? "";
            } else {
                lastMsg = json["last_message"].toString();
            }
        }

        return ChatSession(
            id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
            otherUserId: int.tryParse(json["other_user_id"]?.toString() ?? json["user_two_id"]?.toString() ?? "0") ?? 0,
            otherUserName: name,
            otherUserProfileImage: profileImage,
            lastMessage: lastMsg,
            lastMessageTime: DateTime.parse(json["last_message_time"]?.toString() ?? json["updated_at"]?.toString() ?? DateTime.now().toIso8601String()),
            unreadCount: int.tryParse(json["unread_count"]?.toString() ?? "0") ?? 0,
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "other_user_id": otherUserId,
        "other_user_name": otherUserName,
        "other_user_profile_image": otherUserProfileImage,
        "last_message": lastMessage,
        "last_message_time": lastMessageTime.toIso8601String(),
        "unread_count": unreadCount,
    };
}

class SendMessageResponse {
    bool success;
    String message;
    int? conversationId;

    SendMessageResponse({
        required this.success,
        required this.message,
        this.conversationId,
    });

    factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
        String msg = json["message"]?.toString() ?? "";
        int? convId;
        if (json["data"] != null && json["data"] is Map) {
            if (msg.isEmpty) msg = json["data"]["message"]?.toString() ?? "";
            convId = int.tryParse(json["data"]["conversation_id"]?.toString() ?? "");
        }
        return SendMessageResponse(
            success: json["success"] ?? false,
            message: msg.isEmpty ? "Message sent" : msg,
            conversationId: convId,
        );
    }
}

class ConversationResponse {
    bool success;
    List<ChatMessage> data;

    ConversationResponse({
        required this.success,
        required this.data,
    });

    factory ConversationResponse.fromJson(Map<String, dynamic> json) {
        var dataJson = json["data"];
        List<ChatMessage> messages = [];
        
        if (dataJson is List) {
            messages = dataJson.map((x) => ChatMessage.fromJson(x)).toList();
        } else if (dataJson is Map) {
            // Handle Laravel pagination: {"success": true, "data": {"current_page": 1, "data": [...]}}
            var listData = dataJson["data"];
            if (listData is List) {
                messages = listData.map((x) => ChatMessage.fromJson(x)).toList();
            } else {
                // Fallback for other map structures
                messages = dataJson.values.whereType<Map<String, dynamic>>().map((x) => ChatMessage.fromJson(x)).toList();
            }
        }
        
        return ConversationResponse(
            success: json["success"] ?? false,
            data: messages.reversed.toList(),
        );
    }
}

class ChatMessage {
    int id;
    int senderId;
    int receiverId;
    String message;
    DateTime createdAt;
    bool isMe;

    ChatMessage({
        required this.id,
        required this.senderId,
        required this.receiverId,
        required this.message,
        required this.createdAt,
        required this.isMe,
    });

    factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: int.tryParse(json["id"]?.toString() ?? "0") ?? 0,
        senderId: int.tryParse(json["sender_id"]?.toString() ?? json["user_id"]?.toString() ?? "0") ?? 0,
        receiverId: int.tryParse(json["receiver_id"]?.toString() ?? "0") ?? 0,
        message: json["message"]?.toString() ?? "",
        createdAt: DateTime.parse(json["created_at"]?.toString() ?? DateTime.now().toIso8601String()),
        isMe: json["is_me"]?.toString().toLowerCase() == 'true' || json["is_me"] == 1 || json["is_me"] == true,
    );
}
