import 'package:flutter/material.dart';
import '../../../Themes/app_colors.dart';
import '../../../Themes/app_images.dart';
import 'product_detail_modal.dart';

class RecommendationWidget extends StatelessWidget {
  final int index;
  const RecommendationWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black.withValues(alpha: 0.50),
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation1, animation2) {
            return ProductDetailModal(
              title: 'Tesla Model 3',
              image: AppImages.carimage,
              heroTag: 'rec_$index',
            );
          },
          transitionBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
              opacity: animation1,
              child: Transform.scale(scale: animation1.value, child: child),
            );
          },
        );
      },
      child: SizedBox(
        width: 213,
        height: 230,
        child: Stack(
          children: [
            Hero(
              tag: 'rec_${index}_bg',
              child: Container(
                decoration: ShapeDecoration(
                  color: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF393938),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.17,
                            color: Colors.black.withValues(alpha: 0),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.verified, color: Colors.green, size: 12),
                          SizedBox(width: 5),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Color(0xFF00D66F),
                              fontSize: 12,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Hero(
                      tag: 'rec_$index',
                      child: Image.asset(
                        AppImages.carimage,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Tesla Model 3',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(
                        Icons.battery_0_bar,
                        color: AppColors.primary,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '98%',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.speed, color: AppColors.primary, size: 15),
                      SizedBox(width: 5),
                      Text(
                        '358 mi',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularWidget extends StatelessWidget {
  final int index;
  const PopularWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black.withValues(alpha: 0.50),
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation1, animation2) {
            return ProductDetailModal(
              title: 'Tesla Model 3',
              image: AppImages.popularcar,
              heroTag: 'pop_$index',
            );
          },
          transitionBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
              opacity: animation1,
              child: Transform.scale(scale: animation1.value, child: child),
            );
          },
        );
      },
      child: Stack(
        children: [
          Hero(
            tag: 'pop_${index}_bg',
            child: Container(
              decoration: ShapeDecoration(
                color: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 1,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF393938),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.17,
                          color: Colors.black.withValues(alpha: 0),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, color: Colors.green, size: 12),
                        SizedBox(width: 5),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: Color(0xFF00D66F),
                            fontSize: 12,
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Hero(
                    tag: 'pop_$index',
                    child: Image.asset(
                      AppImages.popularcar,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Tesla Model 3',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.battery_0_bar,
                      color: AppColors.primary,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '98%',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.speed, color: AppColors.primary, size: 15),
                    SizedBox(width: 5),
                    Text(
                      '358 mi',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
