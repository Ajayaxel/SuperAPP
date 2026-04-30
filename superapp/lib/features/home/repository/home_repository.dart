import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_data_model.dart';
import '../services/home_api_service.dart';

class HomeRepository {
  final HomeApiService _apiService;

  HomeRepository({HomeApiService? apiService})
    : _apiService = apiService ?? HomeApiService();

  Future<Data> getHomeData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    final homeDataModel = await _apiService.getHomeData(token);
    return homeDataModel.data;
  }
}
