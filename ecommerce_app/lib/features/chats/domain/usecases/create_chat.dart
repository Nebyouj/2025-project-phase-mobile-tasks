import '../entities/chat.dart';
import '../repositories/chat_repository.dart';

class CreateChat {
  final ChatRepository repository;
  CreateChat(this.repository);

  Future<Chat> call(String participantId) =>
      repository.createChat(participantId);
}
