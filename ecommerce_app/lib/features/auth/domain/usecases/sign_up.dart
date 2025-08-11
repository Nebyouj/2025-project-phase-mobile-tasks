import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository authRepository;

  SignUp(this.authRepository);

  Future<User> call(String name, String email, String password) async {
    return await authRepository.signUp(name, email, password);
  }
}