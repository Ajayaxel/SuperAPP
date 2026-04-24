import 'package:flutter/material.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/features/home/widgets/marketplace_home_widgets.dart';
import 'package:superapp/features/chat/screens/message_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _selectedTab = 'All';

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
                  const Text(
                    'Messages (3)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w700,
                    ),
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
              child: _selectedTab == 'Buying'
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No chats found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: 7,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 5),
                      itemBuilder: (context, index) {
                        return ChatCard(index: index);
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
                const SizedBox(height: 6), // Spacer to prevent jump
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ChatCard extends StatelessWidget {
  final int index;
  const ChatCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final names = [
      'Abbas Ali',
      'Alexandra will',
      'James Jacob',
      'Uma Krishnan',
      'Sara Charles',
      'Mohammed Aman',
      'Uma Krishnan',
    ];
    final avatars = [
      'https://i.pravatar.cc/150?img=11',
      'https://i.pravatar.cc/150?img=5',
      'https://i.pravatar.cc/150?img=12',
      'https://i.pravatar.cc/150?img=16',
      'https://i.pravatar.cc/150?img=20',
      'https://i.pravatar.cc/150?img=33',
      'https://i.pravatar.cc/150?img=26',
    ];
    final unreadCounts = [2, 1, 0, 0, 3, 0, 0];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailScreen(
              name: names[index],
              avatar: avatars[index],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(color: Color(0xFF1C1C1A)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatars[index]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Opacity(
                    opacity: 0.54,
                    child: const Text(
                      'Get up to 4x more views! Featured ads appear above the standard Ads.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '03:26 pm',
                  style: TextStyle(color: AppColors.thirdcolor, fontSize: 12),
                ),
                const SizedBox(height: 8),
                if (unreadCounts[index] > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.btnColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${unreadCounts[index]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 22), // Maintain height
              ],
            ),
          ],
        ),
      ),
    );
  }
}
