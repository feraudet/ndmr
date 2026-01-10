import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class User {
  final String id;
  final String email;
  final String? callsign;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    this.callsign,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      callsign: json['callsign'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}

class AuthService {
  final ApiService _api;
  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'ndmr_access_token';
  static const _refreshTokenKey = 'ndmr_refresh_token';

  AuthService({
    ApiService? api,
    FlutterSecureStorage? storage,
  })  : _api = api ?? ApiService(),
        _storage = storage ?? const FlutterSecureStorage();

  Future<void> _saveTokens(AuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    _api.setAccessToken(tokens.accessToken);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _api.setAccessToken(null);
  }

  Future<String?> getStoredAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getStoredRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Initialize auth state from stored tokens
  Future<bool> initializeAuth() async {
    final accessToken = await getStoredAccessToken();
    if (accessToken != null) {
      _api.setAccessToken(accessToken);
      return true;
    }
    return false;
  }

  /// Register a new user
  Future<User> register({
    required String email,
    required String password,
    String? callsign,
  }) async {
    final response = await _api.post('/auth/register', body: {
      'email': email,
      'password': password,
      if (callsign != null) 'callsign': callsign,
    });
    return User.fromJson(response);
  }

  /// Login with email and password
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    final tokens = AuthTokens.fromJson(response);
    await _saveTokens(tokens);
    return tokens;
  }

  /// Refresh access token using refresh token
  Future<AuthTokens?> refreshTokens() async {
    final refreshToken = await getStoredRefreshToken();
    if (refreshToken == null) {
      return null;
    }

    try {
      final response = await _api.post('/auth/refresh', body: {
        'refresh_token': refreshToken,
      });
      final tokens = AuthTokens.fromJson(response);
      await _saveTokens(tokens);
      return tokens;
    } catch (e) {
      // Refresh failed, clear tokens
      await _clearTokens();
      return null;
    }
  }

  /// Get current user info
  Future<User> getCurrentUser() async {
    final response = await _api.get('/auth/me');
    return User.fromJson(response);
  }

  /// Logout - clear stored tokens
  Future<void> logout() async {
    await _clearTokens();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getStoredAccessToken();
    return token != null;
  }
}
