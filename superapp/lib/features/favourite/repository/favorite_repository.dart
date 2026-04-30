import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_model.dart';
import '../services/favorite_api_service.dart';

class FavoriteRepository {
  final FavoriteApiService _apiService;

  FavoriteRepository({FavoriteApiService? apiService})
      : _apiService = apiService ?? FavoriteApiService();

  Future<FavoriteResponseModel> getFavorites({int page = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return await _apiService.getFavorites(token, page: page);
  }

  Future<Map<String, dynamic>> toggleFavorite(int carListingId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return await _apiService.toggleFavorite(token, carListingId);
  }
}
