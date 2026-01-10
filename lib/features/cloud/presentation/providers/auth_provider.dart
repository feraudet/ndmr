import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/api_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    state = state.copyWith(status: AuthStatus.loading);

    final hasToken = await _authService.initializeAuth();
    if (hasToken) {
      try {
        final user = await _authService.getCurrentUser();
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      } catch (e) {
        // Token might be expired, try to refresh
        final refreshed = await _authService.refreshTokens();
        if (refreshed != null) {
          try {
            final user = await _authService.getCurrentUser();
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
            );
          } catch (_) {
            state = state.copyWith(status: AuthStatus.unauthenticated);
          }
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      }
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? callsign,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      await _authService.register(
        email: email,
        password: password,
        callsign: callsign,
      );
      // Auto-login after registration
      await login(email: email, password: password);
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      await _authService.login(email: email, password: password);
      final user = await _authService.getCurrentUser();
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
