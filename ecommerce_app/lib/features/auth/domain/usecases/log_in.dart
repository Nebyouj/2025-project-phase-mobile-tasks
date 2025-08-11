import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LogIn {
  final AuthRepository repository;

  LogIn(this.repository);

  Future<User> call(String email, String password) async {
    return await repository.logIn(email, password);
  }
}
