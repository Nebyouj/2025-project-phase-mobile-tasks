import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user_typing_status.dart';
import '../../domain/usecases/create_chat.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/get_chats.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChats getChats;
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final CreateChat createChat;
  final GetAllUsers getAllUsers;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  late final StreamSubscription<Message> _messageSubscription;
  late final StreamSubscription<UserTypingStatus> _typingSubscription;

  List<Message> _messages = [];
  String? _currentChatId;

  ChatBloc({
    required this.getChats,
    required this.getMessages,
    required this.sendMessage,
    required this.createChat,
    required this.getAllUsers,
    required Stream<Message> messageStream,
    required Stream<UserTypingStatus> typingStream,
  }) : super(ChatLoading()) {
    // Listen to incoming messages
    _messageSubscription = messageStream.listen((message) {
      add(NewMessageReceived(message));
    });

    // Listen to typing
    _typingSubscription = typingStream.listen((typingStatus) {
      if (typingStatus.isTyping) {
        add(TypingEvent(typingStatus.chatId));
      } else {
        add(StopTypingEvent(typingStatus.chatId));
      }
    });

    // Load all users
    on<LoadUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final users = await getAllUsers();
        emit(UsersLoaded(users));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Create chat with user
    on<CreateChatWithUser>((event, emit) async {
      emit(ChatCreating());
      try {
        final chat = await createChat(event.participantId);
        emit(ChatCreated(chat));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Load all chats
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await getChats();
        emit(ChatLoaded(chats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Load messages
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        _currentChatId = event.chatId;
        _messages = await getMessages(event.chatId);
        emit(MessagesLoaded(List.from(_messages)));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // Send message
    on<SendMessageEvent>((event, emit) async {
      final currentUserId = await secureStorage.read(key: 'userId');
      print('Current User ID: $currentUserId');
      if (currentUserId == null || currentUserId.isEmpty) {
        emit(ChatError('User not authenticated'));
        return;
      }

      try {
        final optimisticMessage = Message(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
          chatId: event.chatId,
          senderId: currentUserId,
          content: event.message,
          type: 'text',
          createdAt: DateTime.now(),
        );

        _messages.add(optimisticMessage);
        emit(MessagesLoaded(List.from(_messages)));

        await sendMessage(event.chatId, event.message);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    // New message received
    on<NewMessageReceived>((event, emit) async {
      if (_currentChatId != null && event.message.chatId == _currentChatId) {
        print(
          'Current chat: $_currentChatId, Incoming chat: ${event.message.chatId}',
        );

        _messages.add(event.message);
        emit(MessagesLoaded(List.from(_messages)));
      }
    });

    // Typing states
    on<TypingEvent>((event, emit) {
      emit(TypingState(event.chatId, true));
    });
    on<StopTypingEvent>((event, emit) {
      emit(TypingState(event.chatId, false));
    });
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    _typingSubscription.cancel();
    return super.close();
  }
}
