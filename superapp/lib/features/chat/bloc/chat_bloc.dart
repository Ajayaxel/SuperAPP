import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc({ChatRepository? repository})
      : _repository = repository ?? ChatRepository(),
        super(ChatInitial()) {
    on<FetchChatsEvent>(_onFetchChats);
    on<FetchConversationEvent>(_onFetchConversation);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkChatAsReadEvent>(_onMarkAsRead);
  }

  Future<void> _onFetchChats(FetchChatsEvent event, Emitter<ChatState> emit) async {
    if (state is! ChatLoaded) {
      emit(ChatLoading());
    }
    
    try {
      final response = await _repository.getChats();
      emit(ChatLoaded(sessions: response.data));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onFetchConversation(FetchConversationEvent event, Emitter<ChatState> emit) async {
    if (state is! ConversationLoaded) {
      emit(ChatLoading());
    }
    
    try {
      // When a conversation is fetched, we should also mark it as read on the backend
      _repository.markAsRead(event.conversationId);
      
      final response = await _repository.getConversation(event.conversationId);
      emit(ConversationLoaded(messages: response.data));
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> _onMarkAsRead(MarkChatAsReadEvent event, Emitter<ChatState> emit) async {
    try {
      await _repository.markAsRead(event.conversationId);
    } catch (e) {
      // Fail silently for background mark-as-read
      print("Error marking chat as read: $e");
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(MessageSending());
    try {
      final response = await _repository.sendMessage(
        receiverId: event.receiverId,
        message: event.message,
      );
      if (response.success) {
        emit(MessageSent(
          message: response.message,
          conversationId: response.conversationId,
        ));
        // Refresh conversation after sending
        if (response.conversationId != null) {
          add(FetchConversationEvent(conversationId: response.conversationId!));
        }
        // Refresh chat list
        add(FetchChatsEvent());
      } else {
        emit(ChatError(message: response.message));
      }
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }
}
