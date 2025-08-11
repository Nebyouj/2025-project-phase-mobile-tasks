import '../../domain/entities/user_typing_status.dart';

class UserTypingStatusModel extends UserTypingStatus {
  UserTypingStatusModel({
    required super.chatId,
    required super.userId,
    required super.isTyping,
  });

  factory UserTypingStatusModel.fromJson(
    Map<String, dynamic> json,
    bool isTyping,
  ) {
    return UserTypingStatusModel(
      chatId: json['chatId'],
      userId: json['userId'],
      isTyping: isTyping,
    );
  }
}
