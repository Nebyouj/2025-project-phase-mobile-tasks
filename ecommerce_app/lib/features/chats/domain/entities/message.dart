import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final String type;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, chatId, senderId, content, type, createdAt];
}
