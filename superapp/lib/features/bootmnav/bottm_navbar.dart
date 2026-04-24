import 'package:flutter/material.dart';
import 'package:superapp/features/home/screens/home_screen.dart';

import 'package:superapp/features/profile/screens/profile_screen.dart';
import 'package:superapp/features/favourite/screens/favourite_screen.dart';
import 'package:superapp/features/chat/screens/chat_screen.dart';
import 'package:superapp/features/home/widgets/post_ad_flow.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0; // Marketplace is active by default as shown in image

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavouriteScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Content scrolls behind the bar
      backgroundColor: Color(0xff111111),
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? Container(
              margin: const EdgeInsets.only(bottom: 5),
              height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.00, 0.02),
                  end: Alignment(1.00, 0.98),
                  colors: [const Color(0xFF35A2BC), const Color(0xFF184A56)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: () => showPostAdFlow(context),
                backgroundColor: Colors.transparent,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                icon: const Icon(Icons.add, color: Colors.white, size: 24),
                label: const Text(
                  'Ad Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        color: Colors.transparent, // Changed to transparent for extendBody
        child: Container(
          padding: EdgeInsets.all(10),
          height: 65,
          decoration: BoxDecoration(
            color: const Color(0xFF111111), // Dark midnight black
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined),
              _buildNavItem(1, Icons.favorite_border_outlined),
              // _buildNavItem(2, Icons.shopping_bag_outlined),
              _buildNavItem(2, Icons.chat_bubble_outline),
              _buildNavItem(3, Icons.person_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = _selectedIndex == index;
    const Color activeColor = Color(0xFF4DD0E1); // Vibrant Cyan/Teal
    const Color inactiveColor = Colors.white;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(index),
        child: Center(
          child: Icon(
            icon,
            size: 25, // Large bold icons
            color: isSelected ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }
}
