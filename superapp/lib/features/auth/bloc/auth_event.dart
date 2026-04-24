import 'package:superapp/features/auth/models/user_model.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String role;
  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
  });
}

class CheckAuthEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class GetProfileEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final String name;
  final String email;
  final String? profileImagePath;
  UpdateProfileEvent({
    required this.name,
    required this.email,
    this.profileImagePath,
  });
}
