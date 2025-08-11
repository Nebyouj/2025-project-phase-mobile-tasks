import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required super.id,
    required super.participants,
    required super.lastMessage,
    required super.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    print('[ChatModel] Parsing chat from JSON: $json');
  return ChatModel(
    id: json['id'] ?? json['_id'] ?? '',
    participants: List<String>.from(json['participants'] ?? [json['user1']['name'],
      json['user2']['name'],]),
    lastMessage: json['lastMessage'] ?? '', // <-- Provide default
    updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
  );
}

  Map<String, dynamic> toJson() => {
    'id': id,
    'participants': participants,
    'lastMessage': lastMessage,
    'updatedAt': updatedAt.toIso8601String(),
  };
}
