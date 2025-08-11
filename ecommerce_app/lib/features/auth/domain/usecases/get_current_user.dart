import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository authRepository;

  GetCurrentUser(this.authRepository);

  Future<User> call() async {
    return await authRepository.getCurrentUser();
  }
}