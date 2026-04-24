import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:superapp/Themes/app_colors.dart';

class ChooseCategorySheet extends StatelessWidget {
  final VoidCallback onBack;
  final Function(String) onCategorySelected;
  const ChooseCategorySheet({
    super.key,
    required this.onBack,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Used Cars', 'New Cars'];

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
                  onTap: onBack,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const Text(
                'Choose Category',
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
              itemCount: categories.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 0.8,
                height: 1,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      title: Text(
                        categories[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => onCategorySelected(categories[index]),
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
