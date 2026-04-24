import 'package:dio/dio.dart';
import 'package:superapp/core/constants/api_constants.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Dio get dio => _dio;

  // Generic GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      print('DEBUG: GET Request to: $path');
      final response = await _dio.get(path, queryParameters: queryParameters, options: options);
      print('DEBUG: GET Response from: $path');
      print('DEBUG: Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('DEBUG: GET Error from: $path');
      print('DEBUG: Error Response: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<Response> post(String path, {dynamic data, Options? options}) async {
    try {
      print('DEBUG: POST Request to: $path');
      print('DEBUG: Request Data: $data');
      final response = await _dio.post(path, data: data, options: options);
      print('DEBUG: POST Response from: $path');
      print('DEBUG: Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('DEBUG: POST Error from: $path');
      print('DEBUG: Error Response: ${e.response?.data}');
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException e) {
    if (e.response != null) {
      // Handle validation errors from backend if any
      if (e.response?.data is Map && e.response?.data['errors'] != null) {
        final errors = e.response?.data['errors'] as Map;
        return errors.values.first.first.toString();
      }
      return e.response?.data['message'] ?? "Something went wrong";
    }
    return "Network error: ${e.message}";
  }
}

// Global instance
final apiService = ApiService();
