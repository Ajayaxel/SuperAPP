import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../models/chat_model.dart';
import 'package:superapp/features/auth/bloc/auth_bloc.dart';
import 'package:superapp/features/auth/bloc/auth_state.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/core/utils/custom_toast.dart';

class ChatDetailScreen extends StatefulWidget {
  final int receiverId;
  final String receiverName;
  final int? conversationId;

  const ChatDetailScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    this.conversationId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  int? _actualReceiverId;

  @override
  void initState() {
    super.initState();
    _actualReceiverId = widget.receiverId;
    if (widget.conversationId != null) {
      context.read<ChatBloc>().add(FetchConversationEvent(conversationId: widget.conversationId!));
    }
  }

  void _sendMessage() {
    final int? receiverId = _actualReceiverId != 0 ? _actualReceiverId : null;
    
    if (receiverId == null || receiverId == 0) {
      CustomToast.show(context, title: 'Error', message: 'Unable to identify receiver', isError: true);
      return;
    }

    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(
            SendMessageEvent(
              receiverId: receiverId,
              message: _messageController.text.trim(),
            ),
          );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ConversationLoaded) {
          // Get current user ID inside listener to ensure it's fresh
          final authState = context.read<AuthBloc>().state;
          int? currentUserId;
          if (authState is ProfileLoaded) {
            currentUserId = authState.user.id;
          } else if (authState is AuthAuthenticated) {
            currentUserId = authState.authResponse.user.id;
          }

          setState(() {
            _messages = state.messages;
            // Autodetect receiver if it's 0 (coming from notification)
            if ((_actualReceiverId == null || _actualReceiverId == 0) && _messages.isNotEmpty) {
              print("DEBUG: Detecting receiver. Current User ID: $currentUserId");
              
              for (var msg in _messages) {
                // If the message sender is not me, they are the receiver of my replies
                if (currentUserId != null && msg.senderId != currentUserId) {
                  _actualReceiverId = msg.senderId;
                  break;
                } 
                // If the message receiver is not me, they are the receiver of my replies
                else if (currentUserId != null && msg.receiverId != currentUserId && msg.receiverId != 0) {
                  _actualReceiverId = msg.receiverId;
                  break;
                }
              }
              print("DEBUG: Final Autodetected receiverId: $_actualReceiverId");
            }
          });
        } else if (state is MessageSent) {
          // Success toast removed as per user request
        } else if (state is ChatError) {
          CustomToast.show(
            context,
            title: 'Error',
            message: state.message,
            isError: true,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          int? currentUserId;
          if (authState is ProfileLoaded) {
            currentUserId = authState.user.id;
          } else if (authState is AuthAuthenticated) {
            currentUserId = authState.authResponse.user.id;
          }

          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                widget.receiverName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(color: Colors.white.withOpacity(0.1), height: 1),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading && _messages.isEmpty) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.btnColor));
                      }

                      if (_messages.isEmpty && state is! ChatLoading) {
                        return const Center(
                          child: Text('Start a conversation', style: TextStyle(color: Colors.grey)),
                        );
                      }

                      return ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        reverse: true, 
                        itemCount: _messages.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final bool isMe = currentUserId != null && msg.senderId == currentUserId;
                          
                          return MessageBubble(
                            message: msg.message,
                            isMe: isMe,
                            time: _formatTime(msg.createdAt),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    top: 8,
                  ),
                  color: Colors.black,
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file, color: Colors.white, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: ShapeDecoration(
                            color: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Type here',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                              BlocBuilder<ChatBloc, ChatState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap: state is MessageSending ? null : _sendMessage,
                                    child: state is MessageSending
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.btnColor,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.send,
                                            color: AppColors.btnColor,
                                            size: 24,
                                          ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppColors.btnColor : const Color(0xFF1C1C1A),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                      fontSize: 15,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: isMe ? Colors.black54 : Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
