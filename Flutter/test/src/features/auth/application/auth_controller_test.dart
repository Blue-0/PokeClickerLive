import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/auth/application/auth_controller.dart';
import 'package:pokeclickerlive/src/features/auth/data/auth_repository.dart';
import 'package:pokeclickerlive/src/features/auth/domain/user.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const User(id: '', username: '', email: ''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();

    // Default behaviors
    when(() => mockAuthRepository.getToken()).thenReturn(null);
    when(() => mockAuthRepository.getUser()).thenReturn(null);
    when(() => mockAuthRepository.saveToken(any())).thenAnswer((_) async {});
    when(() => mockAuthRepository.saveUser(any())).thenAnswer((_) async {});
    when(() => mockAuthRepository.clearAll()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthController', () {
    test('initial state is unauthenticated when no stored credentials', () {
      final state = container.read(authControllerProvider);

      expect(state.isAuthenticated, false);
      expect(state.user, null);
      expect(state.token, null);
      expect(state.isLoading, false);
    });

    test('initial state is authenticated when stored credentials exist', () {
      const user = User(id: '1', username: 'Test', email: 'test@test.com');
      when(() => mockAuthRepository.getToken()).thenReturn('valid_token');
      when(() => mockAuthRepository.getUser()).thenReturn(user);

      // Re-create container to pick up new mock values
      container.dispose();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );

      final state = container.read(authControllerProvider);

      expect(state.isAuthenticated, true);
      expect(state.user, user);
      expect(state.token, 'valid_token');
    });

    test('login with valid credentials sets authenticated state', () async {
      final notifier = container.read(authControllerProvider.notifier);

      await notifier.login('test@test.com', 'password');

      final state = container.read(authControllerProvider);

      expect(state.isAuthenticated, true);
      expect(state.user?.email, 'test@test.com');
      expect(state.token, 'fake_jwt_token');
      expect(state.isLoading, false);
      expect(state.errorMessage, null);

      verify(() => mockAuthRepository.saveUser(any())).called(1);
      verify(() => mockAuthRepository.saveToken('fake_jwt_token')).called(1);
    });

    test('login with invalid credentials shows error message', () async {
      final notifier = container.read(authControllerProvider.notifier);

      await notifier.login('wrong@email.com', 'wrongpassword');

      final state = container.read(authControllerProvider);

      expect(state.isAuthenticated, false);
      expect(state.user, null);
      expect(state.token, null);
      expect(state.isLoading, false);
      expect(state.errorMessage, 'Invalid credentials');

      verifyNever(() => mockAuthRepository.saveUser(any()));
      verifyNever(() => mockAuthRepository.saveToken(any()));
    });

    test('logout clears all stored data and state', () async {
      // First login
      final notifier = container.read(authControllerProvider.notifier);
      await notifier.login('test@test.com', 'password');

      // Verify logged in
      expect(container.read(authControllerProvider).isAuthenticated, true);

      // Logout
      await notifier.logout();

      final state = container.read(authControllerProvider);

      expect(state.isAuthenticated, false);
      expect(state.user, null);
      expect(state.token, null);

      verify(() => mockAuthRepository.clearAll()).called(1);
    });

    test('register returns error (stub implementation)', () async {
      final notifier = container.read(authControllerProvider.notifier);

      await notifier.register('user', 'user@test.com', 'password');

      final state = container.read(authControllerProvider);

      expect(state.isLoading, false);
      expect(state.errorMessage, contains('not yet implemented'));
    });
  });
}
