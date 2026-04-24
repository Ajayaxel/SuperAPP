import 'package:dio/dio.dart';
import 'package:superapp/core/services/storage_service.dart';
import 'package:superapp/features/marketplace/models/car_listing_metadata.dart';
import 'package:superapp/features/marketplace/services/marketplace_api_service.dart';

class MarketplaceRepository {
  final MarketplaceApiService _apiService;

  MarketplaceRepository(this._apiService);

  Future<CarListingMetadata> getCarListingMetadata() async {
    final token = await storageService.getToken();
    if (token == null) throw Exception("Unauthorized");
    return await _apiService.getCarListingMetadata(token);
  }

  Future<void> storeUsedCarListing({
    required Map<String, dynamic> listingData,
    required List<String> imagePaths,
  }) async {
    final token = await storageService.getToken();
    if (token == null) throw Exception("Unauthorized");

    final formDataMap = Map<String, dynamic>.from(listingData);

    // Add images to FormData
    if (imagePaths.isNotEmpty) {
      formDataMap['images[]'] = await Future.wait(
        imagePaths.map((path) => MultipartFile.fromFile(path)),
      );
    }

    final formData = FormData.fromMap(formDataMap);
    await _apiService.storeUsedCarListing(formData, token);
  }
}
