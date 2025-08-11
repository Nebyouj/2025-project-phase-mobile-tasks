import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/auth_status.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/log_in.dart';
import '../../domain/usecases/log_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogIn loginUseCase;
  final SignUp signupUseCase;
  final LogOut logoutUseCase;
  final AuthRepository repository;

  AuthBloc({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.repository,
  }) : super(AuthState.initial()) {
    on<LoginRequested>(_onLogin);
    on<SignupRequested>(_onSignup);
    on<LogoutRequested>(_onLogout);
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthState(status: AuthStatus.authenticating));
    print('AuthBloc: Attempting login for ${event.email}');
    try {
      final user = await loginUseCase(event.email, event.password);
      print('AuthBloc: Login successful');
      final token = await repository.getToken();
      print('AuthBloc: Token retrieved: $token');
      emit(AuthState(status: AuthStatus.isAuthenticated, user: user));
    } catch (e) {
      print('AuthBloc: Login failed - ${e.toString()}');
      emit(
        AuthState(
          status: AuthStatus.error,
          errorMessage: 'Failed to log in: ${e.toString()}',
        ),
      );
    }
  }

Future<void> _onSignup(SignupRequested event, Emitter<AuthState> emit) async {
  emit(AuthState.authenticating());
  try {
    // ignore: unused_local_variable
    final user = await signupUseCase(event.name, event.email, event.password);
    // signup succeeded, now login to get token using the credentials from event
    final loggedInUser = await loginUseCase(event.email, event.password);

    emit(AuthState(status: AuthStatus.isAuthenticated, user: loggedInUser));
  } catch (e) {
    emit(AuthState.error('Failed to sign up: ${e.toString()}'));
  }
}

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    emit(AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthState(status: AuthStatus.authenticating));
    try {
      final user = await repository.getCurrentUser();
      emit(AuthState(status: AuthStatus.isAuthenticated, user: user));
      print('AuthBloc: Checking for current user...');
    } catch (e) {
      emit(AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<String> getToken() async {
    return await repository.getToken();
  }
}
