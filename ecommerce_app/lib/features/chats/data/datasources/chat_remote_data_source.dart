
import '../../../auth/data/models/auth_response_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_typing_status_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats(String token);
  Future<List<MessageModel>> getMessages(String chatId, String token);
  Future<ChatModel> createChat(String participantId, String token);

  // Socket
  Future<void> sendMessage(MessageModel message);
  Future<void> connectSocket(String token);
  Future<void> disconnectSocket();
  Stream<MessageModel> listenToMessages();
  Stream<UserTypingStatusModel> listenToTypingStatus();
  void emitTyping(String chatId);
  void emitStopTyping(String chatId);
  Future<List<AuthResponseModel>> getAllUsers(String token);
}
