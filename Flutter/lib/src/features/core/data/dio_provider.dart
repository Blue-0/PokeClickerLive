import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/data/auth_repository.dart';

part 'dio_provider.g.dart';

/// Determines the appropriate base URL based on platform and environment.
String _getBaseUrl() {
  // TODO: Replace with production URL in release builds
  if (kDebugMode) {
    // Using specific host IP to match PHP server binding
    return 'http://10.176.131.63:8080';
  }
  return 'https://api.pokeclickerlive.com'; // Production URL placeholder
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _getBaseUrl(),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(authRepositoryProvider).getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          // Could trigger a logout here if needed
        }
        return handler.next(e);
      },
    ),
  );

  // M2 FIX: Only add logging in debug mode to avoid exposing sensitive data
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  return dio;
}
