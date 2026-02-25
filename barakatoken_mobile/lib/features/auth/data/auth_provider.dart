import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/features/auth/data/auth_service.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthState {
  final AuthStatus status;
  final String? error;

  AuthState({required this.status, this.error});
}

import 'package:barakatoken_mobile/features/dashboard/data/user_provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final Ref _ref;

  AuthNotifier(this._authService, this._ref) : super(AuthState(status: AuthStatus.loading)) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await _authService.getToken();
    if (token != null) {
      state = AuthState(status: AuthStatus.authenticated);
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String email, String password) async {
    state = AuthState(status: AuthStatus.loading);
    final success = await _authService.login(email, password);
    if (success) {
      state = AuthState(status: AuthStatus.authenticated);
      _ref.invalidate(userProfileProvider);
      return true;
    } else {
      state = AuthState(status: AuthStatus.unauthenticated, error: "Invalid credentials");
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    state = AuthState(status: AuthStatus.loading);
    final success = await _authService.register(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
    if (success) {
      state = AuthState(status: AuthStatus.authenticated);
      _ref.invalidate(userProfileProvider);
      return true;
    } else {
      state = AuthState(status: AuthStatus.unauthenticated, error: "Registration failed");
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});
