
import '../../../auth/domain/entities/user.dart';
import '../entities/chat.dart';
import '../entities/message.dart';
import '../entities/user_typing_status.dart';

abstract class ChatRepository {
  Future<List<Chat>> getChats();
  Future<List<Message>> getMessages(String chatId);
  Future<Chat> createChat(String participantId);

  Stream<Message> listenToMessages();
  Stream<UserTypingStatus> listenToTypingStatus();

  Future<void> sendMessage(String chatId, String message);
  Future<void> connectSocket(String token);
  Future<void> disconnectSocket();
  void emitTyping(String chatId);
  void emitStopTyping(String chatId);
  Future<List<User>> getAllUsers();
}
