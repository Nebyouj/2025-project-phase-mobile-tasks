import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user_typing_status.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage;

  ChatRepositoryImpl(this.remoteDataSource, this.storage);

  @override
  Future<List<Chat>> getChats() async {
    final token = await storage.read(key: 'token') ?? '';
    return await remoteDataSource.getChats(token);
  }

  @override
  Future<List<Message>> getMessages(String chatId) async {
    final token = await storage.read(key: 'token') ?? '';
    final messageModels = await remoteDataSource.getMessages(
      chatId,
      token,
    ); // returns List<MessageModel>
    return messageModels.map((model) => model.toEntity()).toList();
  }

  /// Updated: sendMessage now calls WebSocket sendMessage which returns void.
  /// Changed return type accordingly.
@override
Future<void> sendMessage(String chatId, String message) async {
  // We don't need senderId or id here because the backend handles it
  final msgModel = MessageModel(
    id: '', // not needed for sending
    chatId: chatId,
    senderId: '', // not needed for sending
    content: message,
    type: 'text',
    createdAt: DateTime.now(),
  );

  print('[ChatRepository] Sending minimal message payload');
  await remoteDataSource.sendMessage(msgModel);
}

  @override
  Future<Chat> createChat(String participantId) async {
    final token = await storage.read(key: 'token') ?? '';
    return await remoteDataSource.createChat(participantId, token);
  }

  @override
  Future<void> connectSocket(String token) async {
    await remoteDataSource.connectSocket(token);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final token = await storage.read(key: 'token') ?? '';
    final authResponseList = await remoteDataSource.getAllUsers(token);
    return authResponseList.map((authResponse) => authResponse.user!).toList();
  }

  @override
  Future<void> disconnectSocket() async {
    await remoteDataSource.disconnectSocket();
  }

  @override
  Stream<Message> listenToMessages() {
    return remoteDataSource.listenToMessages().map((messageModel) {
      print(
        '[ChatRepository] listenToMessages stream received: ${messageModel.runtimeType}',
      );
      return messageModel.toEntity();
    });
  }

  @override
  Stream<UserTypingStatus> listenToTypingStatus() {
    return remoteDataSource.listenToTypingStatus();
  }

  @override
  void emitTyping(String chatId) {
    remoteDataSource.emitTyping(chatId);
  }

  @override
  void emitStopTyping(String chatId) {
    remoteDataSource.emitStopTyping(chatId);
  }
}
