import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class FetchChatsEvent extends ChatEvent {}

class FetchConversationEvent extends ChatEvent {
  final int conversationId;
  const FetchConversationEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class SendMessageEvent extends ChatEvent {
  final int receiverId;
  final String message;

  const SendMessageEvent({required this.receiverId, required this.message});

  @override
  List<Object?> get props => [receiverId, message];
}

class MarkChatAsReadEvent extends ChatEvent {
  final int conversationId;
  const MarkChatAsReadEvent({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}
