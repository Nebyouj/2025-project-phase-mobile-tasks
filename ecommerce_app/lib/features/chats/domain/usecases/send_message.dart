import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;
  SendMessage(this.repository);

  Future<void> call(String chatId, String message) =>
      repository.sendMessage(chatId, message);
}
