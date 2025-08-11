import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatId;
  final String chatName;
  final int memberCount;
  final int onlineCount;

  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.chatName,
    this.memberCount = 0,
    this.onlineCount = 0,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages(widget.chatId));
  }

  Widget _buildChatBubble(bool isMe, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomRight: Radius.circular(isMe ? 0 : 20),
              bottomLeft: Radius.circular(isMe ? 20 : 0),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final currentUserId = state.user?.id ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/chatList');
              },
            ),
            title: Row(
              children: [
                const CircleAvatar(radius: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chatName,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.black87),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.videocam, color: Colors.black87),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is MessagesLoaded) {
                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg =
                              state.messages[state.messages.length - index - 1];
                          final isMe =
                              msg.senderId.toString().trim() ==
                              currentUserId.trim();

                          Widget messageContent;
                          if (msg.type == 'text') {
                            messageContent = Text(
                              msg.content,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                              ),
                            );
                          } else if (msg.type == 'image') {
                            messageContent = const Text(
                              'Image message',
                            ); // Placeholder
                          } else if (msg.type == 'video') {
                            messageContent = const Text(
                              'Video message',
                            ); // Placeholder
                          } else if (msg.type == 'file') {
                            messageContent = Text(
                              'File: ${msg.content}',
                            ); // Placeholder
                          } else {
                            messageContent = Text(msg.content);
                          }

                          return _buildChatBubble(isMe, messageContent);
                        },
                      );
                    } else if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatError) {
                      return Center(child: Text(state.error));
                    }
                    return const SizedBox();
                  },
                ),
              ),
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is TypingState && state.isTyping) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'User is typing...',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.grey),
                        onPressed: () {}, // TODO: attach file
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Write your message',
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.content_paste,
                                color: Colors.grey,
                              ),
                              onPressed: () {}, // TODO: paste from clipboard
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.grey),
                        onPressed: () {}, // TODO: open camera
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic, color: Colors.grey),
                        onPressed: () {}, // TODO: record voice
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          final text = _controller.text.trim();
                          if (text.isNotEmpty) {
                            context.read<ChatBloc>().add(
                              SendMessageEvent(widget.chatId, text),
                            );
                            _controller.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
