import 'package:equatable/equatable.dart';
import '../models/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatSession> sessions;
  const ChatLoaded({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

class ConversationLoaded extends ChatState {
  final List<ChatMessage> messages;
  const ConversationLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class MessageSending extends ChatState {}

class MessageSent extends ChatState {
  final String message;
  final int? conversationId;
  const MessageSent({required this.message, this.conversationId});

  @override
  List<Object?> get props => [message, conversationId];
}

class ChatError extends ChatState {
  final String message;
  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
