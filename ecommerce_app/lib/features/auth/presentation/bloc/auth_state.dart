import '../../domain/entities/auth_status.dart';
import '../../domain/entities/user.dart';

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({required this.status, this.user, this.errorMessage});

  factory AuthState.initial() => AuthState(status: AuthStatus.unauthenticated);

  factory AuthState.isAuthenticated(User user) =>
      AuthState(status: AuthStatus.isAuthenticated, user: user);
  factory AuthState.unauthenticated() =>
      AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
  factory AuthState.authenticating() =>
      AuthState(status: AuthStatus.authenticating);


}
