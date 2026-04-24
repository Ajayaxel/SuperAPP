import 'package:superapp/core/services/storage_service.dart';
import 'package:superapp/features/auth/models/user_model.dart';
import 'package:superapp/features/auth/services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _authApiService;
  final StorageService _storageService;

  AuthRepository({
    required AuthApiService authApiService,
    required StorageService storageService,
  })  : _authApiService = authApiService,
        _storageService = storageService;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _authApiService.login(email: email, password: password);
    await _storageService.saveToken(response.token);
    return response;
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
  }) async {
    final response = await _authApiService.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      role: role,
    );
    await _storageService.saveToken(response.token);
    return response;
  }

  Future<UserModel> getProfile() async {
    final token = await _storageService.getToken();
    if (token == null) throw "Unauthorized";
    return await _authApiService.getProfile(token);
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? profileImagePath,
  }) async {
    final token = await _storageService.getToken();
    if (token == null) throw "Unauthorized";
    return await _authApiService.updateProfile(
      token: token,
      name: name,
      email: email,
      profileImagePath: profileImagePath,
    );
  }

  Future<bool> isAuthenticated() async {
    return await _storageService.hasToken();
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
