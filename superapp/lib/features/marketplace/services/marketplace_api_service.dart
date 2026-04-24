import 'package:dio/dio.dart';
import 'package:superapp/core/constants/api_constants.dart';
import 'package:superapp/core/services/api_service.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';

class MarketplaceApiService {
  final ApiService _apiService;

  MarketplaceApiService(this._apiService);

  Future<CarListingMetadata> getCarListingMetadata(String token) async {
    final response = await _apiService.get(
      ApiConstants.usedCarCreateData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.data['success'] == true) {
      return CarListingMetadata.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? "Failed to load car metadata");
    }
  }

  Future<void> storeUsedCarListing(FormData data, String token) async {
    await _apiService.post(
      ApiConstants.usedCarStore,
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
