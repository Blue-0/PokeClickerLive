import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

class AuthRepository {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Gets the stored JWT token synchronously (returns null if not yet loaded)
  String? getToken() {
    return _prefs?.getString(_tokenKey);
  }

  /// Gets the stored JWT token asynchronously
  Future<String?> getTokenAsync() async {
    final prefs = await _preferences;
    return prefs.getString(_tokenKey);
  }

  /// Saves the JWT token to local storage
  Future<void> saveToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString(_tokenKey, token);
  }

  /// Gets the stored user synchronously (returns null if not yet loaded)
  User? getUser() {
    final userJson = _prefs?.getString(_userKey);
    if (userJson == null) return null;
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  /// Gets the stored user asynchronously
  Future<User?> getUserAsync() async {
    final prefs = await _preferences;
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  /// Saves the user to local storage
  Future<void> saveUser(User user) async {
    final prefs = await _preferences;
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Clears all stored authentication data
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Initializes the repository by loading SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
