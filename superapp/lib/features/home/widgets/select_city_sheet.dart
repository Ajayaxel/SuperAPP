import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:superapp/Themes/app_colors.dart';

class SelectCitySheet extends StatelessWidget {
  final Function(String) onCitySelected;
  const SelectCitySheet({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    final List<String> cities = [
      'Abu Dhabi',
      'Ajman',
      'Al Ain',
      'Dubai',
      'Fujairah',
      'Ras al Khaimah',
      'Sharjah',
      'Umm al Quwain',
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
              const Text(
                'Select a City',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: cities.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 0.8,
                height: 1,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      title: Text(
                        cities[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => onCitySelected(cities[index]),
                    )
                    .animate()
                    .fadeIn(delay: (100 + (index * 50)).ms, duration: 400.ms)
                    .slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuart);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }
}
