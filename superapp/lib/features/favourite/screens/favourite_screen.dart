import 'package:flutter/material.dart';
import 'package:superapp/Themes/app_images.dart';
import 'package:superapp/features/home/widgets/marketplace_home_widgets.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Custom Header to match screenshot
                HeaderWidget(),
                const SizedBox(height: 24),
                const Text(
                  'Favourite (3)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    mainAxisExtent: 222,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return FavouriteCarCard(index: index);
                  },
                ),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavouriteCarCard extends StatelessWidget {
  final int index;
  const FavouriteCarCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // Using index to differentiate images if possible
    final String carImage = index == 1
        ? AppImages.popularcar
        : AppImages.carimage;

    return Container(
      width: 174,
      height: 222,
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: const Color(0xFF1C1C1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.favorite, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Center(
            child: Image.asset(
              carImage,
              height: 100, // Adjust to fit within 222 height
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          const Text(
            'Tesla Model 3',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.battery_3_bar, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              const Text(
                '98%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              const Icon(Icons.speed, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              const Text(
                '358 mi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'SF Pro',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
