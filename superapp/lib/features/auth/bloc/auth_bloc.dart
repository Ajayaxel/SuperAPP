import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/features/auth/models/user_model.dart';
import 'package:superapp/features/auth/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<CheckAuthEvent>(_onCheckAuth);
    on<LogoutEvent>(_onLogout);
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        role: event.role,
      );
      emit(AuthAuthenticated(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    if (isAuthenticated) {
      try {
        final user = await _authRepository.getProfile();
        emit(AuthAuthenticated(
          AuthResponse(user: user, token: ''), // Token is already in storage
          isAutoLogin: true,
        ));
      } catch (e) {
        // If profile fetch fails (e.g. token expired), treat as unauthenticated
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onGetProfile(GetProfileEvent event, Emitter<AuthState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await _authRepository.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.updateProfile(
        name: event.name,
        email: event.email,
        profileImagePath: event.profileImagePath,
      );
      emit(ProfileUpdateSuccess(user, "Profile updated successfully"));
      // Also emit ProfileLoaded to update the UI
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
