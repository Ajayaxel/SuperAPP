import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/Themes/app_images.dart';
import 'package:superapp/Themes/app_colors.dart';
import 'package:superapp/features/home/widgets/marketplace_home_widgets.dart';
import 'package:superapp/features/home/models/home_data_model.dart';
import 'package:superapp/features/favourite/bloc/favorite_bloc.dart';
import 'package:superapp/features/favourite/bloc/favorite_event.dart';
import 'package:superapp/features/favourite/bloc/favorite_state.dart';
import 'package:superapp/core/widgets/app_loading.dart';
import 'package:superapp/core/widgets/skeleton_loading.dart';
import 'package:superapp/features/home/widgets/product_detail_modal.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
    final favoriteState = context.read<FavoriteBloc>().state;
    if (favoriteState is! FavoriteLoaded) {
      context.read<FavoriteBloc>().add(const FetchFavoritesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: BlocListener<FavoriteBloc, FavoriteState>(
          listener: (context, state) {
            if (state is ToggleFavoriteSuccess) {
              context.read<FavoriteBloc>().add(const FetchFavoritesEvent());
            }
          },
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FavoriteBloc>().add(const FetchFavoritesEvent());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        HeaderWidget(),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text(
                              'Favourite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (state is FavoriteLoaded) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(${state.favoriteData.total})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'SF Pro',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ] else if (state is FavoriteLoading) ...[
                              const SizedBox(width: 8),
                              state.previousData != null
                                  ? Text(
                                      '(${state.previousData!.total})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'SF Pro',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : const SkeletonLoading(width: 30, height: 20),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (state is FavoriteLoading)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.previousData?.listings.length ?? 6,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 222,
                            ),
                            itemBuilder: (context, index) =>
                                FavouriteCarCard.skeleton(index: index),
                          )
                        else if (state is FavoriteError)
                          Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        else if (state is FavoriteLoaded)
                          state.favoriteData.listings.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Text(
                                      'No favorites yet',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15,
                                        mainAxisSpacing: 15,
                                        mainAxisExtent: 222,
                                      ),
                                  itemCount: state.favoriteData.listings.length,
                                  itemBuilder: (context, index) {
                                    return FavouriteCarCard(
                                      car: state.favoriteData.listings[index],
                                      index: index,
                                    );
                                  },
                                )
                        else
                          const SizedBox.shrink(),
                        const SizedBox(height: 100), // Space for bottom nav
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FavouriteCarCard extends StatelessWidget {
  final FreshRecommendation? car;
  final int index;
  final bool isLoading;

  const FavouriteCarCard({
    super.key,
    this.car,
    required this.index,
    this.isLoading = false,
  });

  const FavouriteCarCard.skeleton({super.key, required this.index})
      : car = null,
        isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SkeletonLoading(
        width: 174,
        height: 222,
        borderRadius: 10,
      );
    }

    final carData = car;
    if (carData == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black.withValues(alpha: 0.50),
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation1, animation2) {
            return ProductDetailModal(car: carData, heroTag: 'fav_$index');
          },
          transitionBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
              opacity: animation1,
              child: Transform.scale(scale: animation1.value, child: child),
            );
          },
        );
      },
      child: Container(
        width: 174,
        height: 222,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: const Color(0xFF1C1C1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  context.read<FavoriteBloc>().add(
                    ToggleFavoriteEvent(carListingId: carData.id),
                  );
                },
                icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
              ),
            ),
            const Spacer(),
            Center(
              child: Hero(
                tag: 'fav_$index',
                child: carData.images.isNotEmpty
                    ? Image.network(
                        carData.images.first.imageUrl,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SkeletonLoading(
                            width: double.infinity,
                            height: 80,
                            borderRadius: 12,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              AppImages.carimage,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                      )
                    : Image.asset(
                        AppImages.carimage,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            const Spacer(),
            Text(
              carData.title.isNotEmpty
                  ? carData.title
                  : '${carData.make.name} ${carData.model.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
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
                Text(
                  '${carData.kilometers} km',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'SF Pro',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
