import '../../../auth/domain/entities/user.dart';
import '../repositories/chat_repository.dart';

class GetAllUsers {
  final ChatRepository repository;

  GetAllUsers(this.repository);

  Future<List<User>> call() {
    return repository.getAllUsers();
  }
}