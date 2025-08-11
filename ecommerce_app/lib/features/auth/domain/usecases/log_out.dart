import '../repositories/auth_repository.dart';

class LogOut {
  final AuthRepository _authRepository;

  LogOut(this._authRepository);

  Future<void> call() async {
    await _authRepository.logOut();
  }
}