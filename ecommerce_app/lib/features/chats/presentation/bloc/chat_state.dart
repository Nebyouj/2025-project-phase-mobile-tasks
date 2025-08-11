
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;
  ChatLoaded(this.chats);
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}

class MessageSentSuccess extends ChatState {}

class ChatCreated extends ChatState {
  final Chat chat;
  ChatCreated(this.chat);
}

class TypingState extends ChatState {
  final String chatId;
  final bool isTyping;
  TypingState(this.chatId, this.isTyping);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}

class UsersLoading extends ChatState {}
class UsersLoaded extends ChatState {
  final List<dynamic> users; // Replace dynamic with User if you have entity
  UsersLoaded(this.users);
}

class ChatCreating extends ChatState {}


