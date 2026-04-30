import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/home_data_model.dart';

class HomeApiService {
  Future<HomeDataModel> getHomeData(String token) async {
    try {
      final response = await apiService.get(
        '/api/home',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return HomeDataModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
