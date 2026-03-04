import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/user.dart';
import '../../core/data/dio_provider.dart';
import '../../collection/domain/user_pokemon.dart';
import '../../shop/domain/inventory.dart';
import '../../sync/application/sync_controller.dart';

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

  /// Clears all Hive boxes that contain per-user local game data.
  /// Called on login (when the user changes) and on logout, so that
  /// no player ever sees another player's cached Pokémon or progress.
  Future<void> _clearLocalHiveData() async {
    if (Hive.isBoxOpen('user_pokemon')) {
      await Hive.box<UserPokemon>('user_pokemon').clear();
    }
    if (Hive.isBoxOpen('team')) {
      await Hive.box<List<String>>('team').clear();
    }
    if (Hive.isBoxOpen('inventory')) {
      await Hive.box<Inventory>('inventory').clear();
    }
    if (Hive.isBoxOpen('upgrade_levels')) {
      await Hive.box<Map>('upgrade_levels').clear();
    }
    if (Hive.isBoxOpen('prestige')) {
      await Hive.box<Map<dynamic, dynamic>>('prestige').clear();
    }
    if (Hive.isBoxOpen('zone_data')) {
      try {
        await Hive.box('zone_data').clear();
      } catch (_) {}
    }
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

        // If a different user was previously stored locally, wipe their data
        // before writing the new session so collections never get mixed.
        final previousUser = repo.getUser();
        if (previousUser != null &&
            previousUser.id.toString() != user.id.toString()) {
          await _clearLocalHiveData();
        }

        await repo.saveUser(user);
        await repo.saveToken(token);

        state = state.copyWith(user: user, token: token, isLoading: false);

        // Restore cloud progress after login.
        // Scheduled after the current event so the router can redirect to home
        // and game controllers can initialize before data is applied.
        Future(() async {
          await ref.read(syncControllerProvider.notifier).loadAndRestore();
        });
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

        // If a different user was previously stored locally, wipe their data
        // before writing the new session so collections never get mixed.
        final previousUser = repo.getUser();
        if (previousUser != null &&
            previousUser.id.toString() != user.id.toString()) {
          await _clearLocalHiveData();
        }

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
    // Clear credentials first, then wipe all local game data so the next
    // user who logs in on this device starts with a clean slate.
    await repo.clearAll();
    await _clearLocalHiveData();
    state = const AuthState();
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }
}
