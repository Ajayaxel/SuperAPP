import 'package:superapp/features/home/models/home_data_model.dart';

class FavoriteResponseModel {
  final bool success;
  final FavoriteData data;

  FavoriteResponseModel({
    required this.success,
    required this.data,
  });

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) => FavoriteResponseModel(
        success: json["success"] ?? false,
        data: FavoriteData.fromJson(json["data"] ?? {}),
      );
}

class FavoriteData {
  final int currentPage;
  final List<FreshRecommendation> listings;
  final int lastPage;
  final int total;

  FavoriteData({
    required this.currentPage,
    required this.listings,
    required this.lastPage,
    required this.total,
  });

  factory FavoriteData.fromJson(Map<String, dynamic> json) => FavoriteData(
        currentPage: json["current_page"] ?? 1,
        listings: json["data"] != null
            ? List<FreshRecommendation>.from(json["data"].map((x) => FreshRecommendation.fromJson(x)))
            : [],
        lastPage: json["last_page"] ?? 1,
        total: json["total"] ?? 0,
      );
}
