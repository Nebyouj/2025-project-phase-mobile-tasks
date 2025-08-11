import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as client;
import '../../../../core/network/socket_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../auth/data/models/auth_response_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_typing_status_model.dart';
import 'chat_remote_data_source.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FlutterSecureStorage secureStorage;
  final WebSocketService socketService;

  ChatRemoteDataSourceImpl(this.secureStorage, this.socketService);

  final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();
  final StreamController<UserTypingStatusModel> _typingController =
      StreamController<UserTypingStatusModel>.broadcast();

  @override
  Future<List<ChatModel>> getChats(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['data'] is List) {
        final List dataList = decoded['data'];
        return dataList.map((e) => ChatModel.fromJson(e)).toList();
      } else {
        throw Exception(
          "Expected 'data' to be a List, got ${decoded['data'].runtimeType}",
        );
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) {
        return data.map((e) => MessageModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } else if (decoded is List) {
      // Handle the case where API returns list directly (if applicable)
      return decoded.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  @override
  Future<ChatModel> createChat(String participantId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'userId': participantId}),
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return ChatModel.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to create chat');
    }
  }

  @override
  Future<List<AuthResponseModel>> getAllUsers(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      final List<dynamic> jsonList = decodedJson['data'];
      return jsonList
          .map<AuthResponseModel>(
            (json) => AuthResponseModel.fromUserJson(json),
          )
          .toList();
    } else {
      throw Exception(
        'Failed to load users. Status code: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // Socket methods
  @override
  Future<void> connectSocket(String token) async {
    await socketService.connect(token);

    // Hook socket events to broadcast streams
    // Update the socket message handler
    socketService.onMessageReceived = (msg) {
      print('[Debug] WebSocket message received, type: ${msg.toJson()}');
      _messageController.add(msg);
    };

    socketService.onTyping = (data) {
      _typingController.add(UserTypingStatusModel.fromJson(data, true));
    };

    socketService.onStopTyping = (data) {
      _typingController.add(UserTypingStatusModel.fromJson(data, false));
    };
  }

  @override
  Future<void> disconnectSocket() async {
    socketService.disconnect();
    _messageController.close();
    _typingController.close();
  }

  @override
  Stream<MessageModel> listenToMessages() {
    print('[ChatRemoteDataSource] listenToMessages stream accessed');
    return _messageController.stream.map((msg) {
      print(
        '[ChatRemoteDataSource] Emitting message model: ${msg.runtimeType}',
      );
      return msg;
    });
  }

  @override
  Stream<UserTypingStatusModel> listenToTypingStatus() {
    return _typingController.stream;
  }

  @override
  void emitStopTyping(String chatId) {
    socketService.emitStopTyping(chatId);
  }

  @override
  void emitTyping(String chatId) {
    socketService.emitTyping(chatId);
  }

  /// Send message via WebSocket
  Future<void> sendMessage(MessageModel message) async {
  final payload = {
    'chatId': message.chatId,
    'content': message.content,
    'type': message.type,
  };
  print('[ChatRemoteDataSource] Emitting message payload: $payload');
  socketService.sendMessage(payload);
}

  /// Dispose method to close the streams when no longer needed
  void dispose() {
    _messageController.close();
    _typingController.close();
  }
}
