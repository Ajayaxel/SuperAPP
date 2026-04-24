import 'package:dio/dio.dart';
import 'package:superapp/core/constants/api_constants.dart';
import 'package:superapp/core/services/api_service.dart';
import 'package:superapp/features/auth/models/user_model.dart';

class AuthApiService {
  Future<AuthResponse> login({
    required String email,
    required String password,
    String deviceName = 'mobile',
  }) async {
    try {
      final response = await apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    try {
      final response = await apiService.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'role': role,
        },
      );
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getProfile(String token) async {
    try {
      final response = await apiService.get(
        ApiConstants.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // Handle nested user object if present
      final responseData = response.data;
      if (responseData is Map && responseData.containsKey('user')) {
        return UserModel.fromJson(responseData['user']);
      }
      return UserModel.fromJson(responseData);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> updateProfile({
    required String token,
    required String name,
    required String email,
    String? profileImagePath,
  }) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'email': email,
      };

      if (profileImagePath != null) {
        data['profile_image'] = await MultipartFile.fromFile(profileImagePath);
      }

      final response = await apiService.post(
        ApiConstants.updateProfile,
        data: FormData.fromMap(data),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      // Handle nested user object if present
      final responseData = response.data;
      if (responseData is Map && responseData.containsKey('user')) {
        return UserModel.fromJson(responseData['user']);
      }
      
      return UserModel.fromJson(responseData);
    } catch (e) {
      rethrow;
    }
  }
}
