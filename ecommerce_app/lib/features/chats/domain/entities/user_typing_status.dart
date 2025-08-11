class UserTypingStatus {
  final String chatId;
  final String userId;
  final bool isTyping;

  UserTypingStatus({
    required this.chatId,
    required this.userId,
    required this.isTyping,
  });
}
