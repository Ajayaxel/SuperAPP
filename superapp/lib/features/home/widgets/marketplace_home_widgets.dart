import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../auth/models/user_model.dart';
import '../../../Themes/app_colors.dart';
import '../../../Themes/app_images.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserModel? user;
        if (state is ProfileLoaded) {
          user = state.user;
        } else if (state is AuthAuthenticated) {
          user = state.authResponse.user;
        } else if (state is ProfileUpdateSuccess) {
          user = state.user;
        }

        final String userName = user?.name ?? 'Loading...';
        final String? profileImageUrl = user?.profileImageUrl;

        return Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: profileImageUrl != null && profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : const NetworkImage(
                          "https://img.freepik.com/premium-vector/man-avatar-profile-round-icon_24640-14044.jpg?w=360",
                        ),
                  fit: BoxFit.cover,
                ),
                shape: const OvalBorder(),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good morning!',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontFamily: 'SF-PRO',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontFamily: 'SF-PRO',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.favorite_outline,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.notifications_none,
              color: AppColors.primary,
              size: 24,
            ),
          ],
        );
      },
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 41,
      child: TextFormField(
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontFamily: 'SF Pro',
        ),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.secondary,
          filled: true,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: AppColors.primary.withValues(alpha: 0.70),
            fontSize: 14,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primary.withValues(alpha: 0.70),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      height: 139,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.bannerimage),
          fit: BoxFit.cover,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Up to 15% Off',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          SizedBox(
            width: 128,
            child: Opacity(
              opacity: 0.80,
              child: Text(
                'Lorem ipsum dolor sit amet consectetur. Ornare sed at lorem nibh lacus egestas aliquam.',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CategoryRowWidget(),
        CategoryRowWidget(),
        CategoryRowWidget(),
        CategoryRowWidget(),
      ],
    );
  }
}

class CategoryRowWidget extends StatelessWidget {
  const CategoryRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77,
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: AppColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Column(
        children: [
          Icon(Icons.car_rental, color: AppColors.primary, size: 24),
          SizedBox(height: 5),
          Text(
            'EV Cars',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
