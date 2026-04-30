import 'package:dio/dio.dart';
import 'package:superapp/core/services/api_service.dart';
import '../models/favorite_model.dart';

class FavoriteApiService {
  Future<FavoriteResponseModel> getFavorites(String token, {int page = 1}) async {
    try {
      final response = await apiService.get(
        '/api/favorites?page=$page',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return FavoriteResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> toggleFavorite(String token, int carListingId) async {
    try {
      final response = await apiService.post(
        '/api/favorites/toggle',
        data: {'car_listing_id': carListingId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
