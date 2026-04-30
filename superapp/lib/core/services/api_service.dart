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
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('DEBUG: GET Request to: $path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
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

  // Generic DELETE request
  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      print('DEBUG: DELETE Request to: $path');
      final response = await _dio.delete(path, data: data, options: options);
      print('DEBUG: DELETE Response from: $path');
      print('DEBUG: Response Data: ${response.data}');
      return response;
    } on DioException catch (e) {
      print('DEBUG: DELETE Error from: $path');
      print('DEBUG: Error Response: ${e.response?.data}');
      throw _handleError(e);
    }
  }


  // Error handling
  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map) {
        // Handle Laravel style validation errors: {"message": "...", "errors": {"field": ["error"]}}
        if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            } else if (firstError is String) {
              return firstError;
            } else if (firstError is Map && firstError.isNotEmpty) {
              // Sometimes it's nested
              return firstError.values.first.toString();
            }
          }
        }
        // Handle common message field
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          return data['message'].toString();
        }
        // Handle error field
        if (data['error'] != null && data['error'].toString().isNotEmpty) {
          return data['error'].toString();
        }
      }
      return "Error: ${e.response?.statusCode} - ${e.response?.statusMessage ?? 'Something went wrong'}";
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Connection timed out. Please check your internet.";
    } else if (e.type == DioExceptionType.connectionError) {
      return "No internet connection.";
    }

    return "Something went wrong. Please try again.";
  }
}

// Global instance
final apiService = ApiService();
