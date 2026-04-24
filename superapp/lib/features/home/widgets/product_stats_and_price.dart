import 'package:flutter/material.dart';

class ProductStatsAndPrice extends StatelessWidget {
  final String heroTag;
  final String price;

  const ProductStatsAndPrice({
    super.key,
    required this.heroTag,
    this.price = 'AED 45,000',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Box
        Hero(
          tag: '${heroTag}_stats',
          child: Container(
            decoration: ShapeDecoration(
              color: const Color(0xFF626262),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.calendar_today_outlined, '2022'),
                _buildDivider(30),
                _buildStatItem(Icons.speed_outlined, '42,000 km'),
                _buildDivider(30),
                _buildStatItem(
                  Icons.settings_input_component_outlined,
                  'Left Hand',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),

        // Price and Call
        Hero(
          tag: '${heroTag}_price',
          child: Material(
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    price,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text(
                    'Call',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EB5C3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(double height) {
    return Container(height: height, width: 1, color: Colors.white24);
  }
}
