import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/features/home/widgets/marketplace_home_widgets.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../models/chat_model.dart';
import 'chat_detail_screen.dart';
import 'package:superapp/core/widgets/skeleton_loading.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedTab = 'All';
  List<ChatSession> _sessions = []; // Local cache to prevent skeleton during refreshes

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const HeaderWidget(),
                  const SizedBox(height: 30),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoaded) {
                        _sessions = state.sessions;
                      }
                      return Text(
                        'Messages (${_sessions.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ChatTabBar(
                    selectedTab: _selectedTab,
                    onTabChanged: (tab) {
                      setState(() {
                        _selectedTab = tab;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoaded) {
                    _sessions = state.sessions;
                  }

                  if (_sessions.isNotEmpty) {
                    // Show the cached list even if we are loading or in another state
                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: _sessions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 1),
                      itemBuilder: (context, index) {
                        final session = _sessions[index];
                        return ChatCard(
                          session: session,
                          onTap: () {
                            // Optimistically clear unread count when opening the chat
                            setState(() {
                              session.unreadCount = 0;
                            });
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailScreen(
                                  receiverId: session.otherUserId,
                                  receiverName: session.otherUserName,
                                  conversationId: session.id,
                                ),
                              ),
                            ).then((_) {
                              if (context.mounted) {
                                context.read<ChatBloc>().add(FetchChatsEvent());
                              }
                            });
                          },
                        );
                      },
                    );
                  } else if (state is ChatLoading || state is ChatInitial) {
                    // Only show skeleton if we have NO cached data
                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: 6,
                      separatorBuilder: (context, index) => const SizedBox(height: 1),
                      itemBuilder: (context, index) => const SkeletonLoading(
                        width: double.infinity,
                        height: 80,
                        borderRadius: 0,
                      ),
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTabBar extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabChanged;

  const ChatTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Buying', 'Selling', 'Unread'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: tabs.map((tab) {
        final bool isSelected = tab == selectedTab;
        return GestureDetector(
          onTap: () => onTabChanged(tab),
          child: Column(
            children: [
              Text(
                tab,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 2,
                  width: 25,
                  color: AppColors.thirdcolor,
                )
              else
                const SizedBox(height: 6),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ChatCard extends StatelessWidget {
  final ChatSession session;
  final VoidCallback onTap; // Added onTap callback
  
  const ChatCard({
    super.key, 
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: Color(0xFF1C1C1A)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                session.otherUserProfileImage ?? "https://i.pravatar.cc/150?img=11",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.otherUserName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(session.lastMessageTime),
                  style: const TextStyle(color: AppColors.thirdcolor, fontSize: 12),
                ),
                const SizedBox(height: 8),
                if (session.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: AppColors.btnColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${session.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
