import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokeclickerlive/src/features/auth/data/auth_repository.dart';
import 'go_router_refresh_stream.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/clicker/presentation/clicker_screen.dart';
// import '../features/auth/application/auth_controller.dart';

enum AppRoute { login, home }

final routerProvider = Provider<GoRouter>((ref) {
  // Use AuthRepository directly or a StreamProvider for auth state
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/', // Start at home, redirect will handle auth
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const ClickerScreen(),
      ),
    ],
  );
});
