import 'package:flutter/material.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/core/widgets/app_loading.dart';

class Btn extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;

  const Btn({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      height: screenWidth * 0.11, // responsive height
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.btnColor,
          disabledBackgroundColor: AppColors.btnColor.withOpacity(0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.1, // responsive padding
          ),
        ),
        child: isLoading
            ? const AppLoading(radius: 8)
            : FittedBox(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }
}
