import 'package:superapp/features/auth/models/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthResponse authResponse;
  final bool isAutoLogin;
  AuthAuthenticated(this.authResponse, {this.isAutoLogin = false});
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

// Profile specific states for finer control
class ProfileLoading extends AuthState {}

class ProfileLoaded extends AuthState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileUpdateSuccess extends AuthState {
  final UserModel user;
  final String message;
  ProfileUpdateSuccess(this.user, this.message);
}
