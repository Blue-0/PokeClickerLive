import 'package:freezed_annotation/freezed_annotation.dart';
import 'user.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    User? user,
    String? token,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get isAuthenticated => token != null && user != null;
}
