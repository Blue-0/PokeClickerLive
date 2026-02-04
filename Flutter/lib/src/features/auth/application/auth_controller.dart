import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/user.dart';
import '../../core/data/dio_provider.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    final repo = ref.read(authRepositoryProvider);
    final user = repo.getUser();
    final token = repo.getToken();

    return AuthState(user: user, token: token);
  }

  /// Authenticates user with email and password.
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.data['status'] == 'success') {
        final userData = response.data['data']['user'];
        final token = response.data['data']['token'] as String;

        final user = User.fromJson(Map<String, dynamic>.from(userData));

        final repo = ref.read(authRepositoryProvider);
        await repo.saveUser(user);
        await repo.saveToken(token);

        state = state.copyWith(user: user, token: token, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Registers a new user account.
  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post(
        '/api/auth/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      if (response.data['status'] == 'success') {
        final userData = response.data['data']['user'];
        final token = response.data['data']['token'] as String;

        final user = User.fromJson(Map<String, dynamic>.from(userData));

        final repo = ref.read(authRepositoryProvider);
        await repo.saveUser(user);
        await repo.saveToken(token);

        state = state.copyWith(user: user, token: token, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.data['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.clearAll();
    state = const AuthState();
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }
}
