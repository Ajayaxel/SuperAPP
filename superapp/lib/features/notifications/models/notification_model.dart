import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

class NotificationResponse {
  final bool success;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
        success: json["success"] ?? false,
        data: NotificationData.fromJson(json["data"] ?? {}),
      );
}

class NotificationData {
  final int currentPage;
  final List<NotificationItem> data;
  final int total;

  NotificationData({
    required this.currentPage,
    required this.data,
    required this.total,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
        currentPage: json["current_page"] ?? 1,
        data: List<NotificationItem>.from((json["data"] ?? []).map((x) => NotificationItem.fromJson(x))),
        total: json["total"] ?? 0,
      );
}

class NotificationItem {
  final String id;
  final String type;
  final NotificationContent content;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.type,
    required this.content,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json["id"] ?? "",
        type: json["type"] ?? "",
        content: NotificationContent.fromJson(json["data"] ?? {}),
        readAt: json["read_at"] != null ? DateTime.parse(json["read_at"]) : null,
        createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
      );
}

class NotificationContent {
  final String type;
  final String title;
  final String message;
  final int? conversationId;
  final int? senderId; // Added senderId

  NotificationContent({
    required this.type,
    required this.title,
    required this.message,
    this.conversationId,
    this.senderId,
  });

  factory NotificationContent.fromJson(Map<String, dynamic> json) => NotificationContent(
        type: json["type"] ?? "",
        title: json["title"] ?? "",
        message: json["message"] ?? "",
        conversationId: int.tryParse(json["conversation_id"]?.toString() ?? ""),
        senderId: int.tryParse(json["sender_id"]?.toString() ?? json["user_id"]?.toString() ?? ""),
      );
}
