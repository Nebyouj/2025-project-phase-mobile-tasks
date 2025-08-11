class Chat {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });

  String get name => participants.join();

  String get lastMessageTime => 
      '${updatedAt.hour.toString().padLeft(2, '0')}:${updatedAt.minute.toString().padLeft(2, '0')}';

  get unreadCount => null;
}
