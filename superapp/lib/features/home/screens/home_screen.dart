import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/features/auth/bloc/auth_bloc.dart';
import 'package:superapp/features/auth/bloc/auth_event.dart';
import 'package:superapp/features/home/widgets/marketplace_home_widgets.dart';
import 'package:superapp/features/home/widgets/marketplace_product_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user profile to ensure name is updated on home screen
    context.read<AuthBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const SizedBox(height: 33),
                const SearchBox(),
                const SizedBox(height: 16),
                const BannerWidget(),
                const SizedBox(height: 16),
                const Text(
                  'Category',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const CategoryList(),
                const SizedBox(height: 16),
                const Text(
                  'Fresh recommendations',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: index == 9 ? 10 : 8),
                        child: RecommendationWidget(index: index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Popular',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return PopularWidget(index: index);
                  },
                ),
                const SizedBox(
                  height: 80,
                ), // Added bottom padding to avoid FAB overlap
              ],
            ),
          ),
        ),
      ),
    );
  }
}
