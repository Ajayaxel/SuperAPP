import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/features/auth/bloc/auth_bloc.dart';
import 'package:superapp/features/auth/bloc/auth_event.dart';
import 'package:superapp/features/home/widgets/marketplace_home_widgets.dart';
import 'package:superapp/features/home/widgets/marketplace_product_widgets.dart';
import 'package:superapp/features/home/bloc/home_bloc.dart';
import 'package:superapp/features/home/bloc/home_event.dart';
import 'package:superapp/features/home/bloc/home_state.dart';
import 'package:superapp/core/widgets/skeleton_loading.dart';

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
    
    final homeState = context.read<HomeBloc>().state;
    if (homeState is! HomeLoaded) {
      context.read<HomeBloc>().add(FetchHomeDataEvent());
    }
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
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return const HomeSkeleton();
                    } else if (state is HomeLoaded) {
                      final fresh = state.homeData.freshRecommendations;
                      final popular = state.homeData.popularListings;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 24),
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
                              itemCount: fresh.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == fresh.length - 1 ? 10 : 8,
                                  ),
                                  child: RecommendationWidget(
                                    index: index,
                                    car: fresh[index],
                                  ),
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
                            itemCount: popular.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.85,
                            ),
                            itemBuilder: (context, index) {
                              return PopularWidget(
                                index: index,
                                car: popular[index],
                              );
                            },
                          ),
                        ],
                      );
                    } else if (state is HomeError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
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
