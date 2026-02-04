import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/user.dart';

part 'auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

class AuthRepository {
  final _box = Hive.box('auth');

  String? getToken() => _box.get('token');

  Future<void> saveToken(String token) async {
    await _box.put('token', token);
  }

  Future<void> deleteToken() async {
    await _box.delete('token');
  }

  Future<void> saveUser(User user) async {
    await _box.put('user', user.toJson());
  }

  User? getUser() {
    final data = _box.get('user');
    if (data == null) return null;
    return User.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}
