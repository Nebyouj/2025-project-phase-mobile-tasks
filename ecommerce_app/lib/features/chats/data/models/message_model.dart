import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.content,
    required super.type,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
  print('[MessageModel] Parsing message from JSON: $json');
  return MessageModel(
    id: json['id'] ?? json['_id'] ?? '',
    chatId: json['chatId'] ?? (json['chat']?['_id'] ?? ''),
    senderId: json['senderId'] ?? (json['sender']?['_id'] ?? ''),
    content: json['content'] ?? '',
    type: json['type'] ?? 'text',
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt']) 
        : DateTime.now(),
  );
}

  Map<String, dynamic> toJson() => {
    'id': id,
    'chatId': chatId,
    'senderId': senderId,
    'content': content,
    'type': type,
    'createdAt': createdAt.toIso8601String(),
  };

  
  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      chatId: message.chatId,
      senderId: message.senderId,
      content: message.content,
      type: message.type,
      createdAt: message.createdAt,
    );
  }

  Message toEntity() {
    return Message(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: type,
      createdAt: createdAt,
    );
  }

}
