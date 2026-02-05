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
    when(
      () => mockAuthRepository.getTokenAsync(),
    ).thenAnswer((_) async => null);
    when(() => mockAuthRepository.getUserAsync()).thenAnswer((_) async => null);
    when(() => mockAuthRepository.saveToken(any())).thenAnswer((_) async {});
    when(() => mockAuthRepository.saveUser(any())).thenAnswer((_) async {});
    when(() => mockAuthRepository.clearAll()).thenAnswer((_) async {});
    when(() => mockAuthRepository.init()).thenAnswer((_) async {});

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

    test('logout clears all stored data and state', () async {
      // First set up authenticated state
      const user = User(id: '1', username: 'Test', email: 'test@test.com');
      when(() => mockAuthRepository.getToken()).thenReturn('valid_token');
      when(() => mockAuthRepository.getUser()).thenReturn(user);

      container.dispose();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
      );

      // Verify logged in
      expect(container.read(authControllerProvider).isAuthenticated, true);

      // Logout
      final notifier = container.read(authControllerProvider.notifier);
      await notifier.logout();

      final state = container.read(authControllerProvider);

      expect(state.isAuthenticated, false);
      expect(state.user, null);
      expect(state.token, null);

      verify(() => mockAuthRepository.clearAll()).called(1);
    });
  });
}
