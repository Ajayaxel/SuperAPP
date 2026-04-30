import 'package:equatable/equatable.dart';
import 'car_listing_model.dart';

class HomeResponseModel extends Equatable {
  final bool success;
  final List<CarListingModel> freshRecommendations;
  final List<CarListingModel> popularListings;

  const HomeResponseModel({
    required this.success,
    required this.freshRecommendations,
    required this.popularListings,
  });

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    return HomeResponseModel(
      success: json['success'] ?? false,
      freshRecommendations: (data?['fresh_recommendations'] as List<dynamic>?)
              ?.map((e) => CarListingModel.fromJson(e))
              .toList() ??
          [],
      popularListings: (data?['popular_listings'] as List<dynamic>?)
              ?.map((e) => CarListingModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [success, freshRecommendations, popularListings];
}
