import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatBloc>()..add(LoadChats()),
      child: Scaffold(
        backgroundColor: Colors.blue[700],
        appBar: AppBar(
    backgroundColor: Colors.blue[700],
    elevation: 1,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black87),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    ),
    title: const Text('Chats'),
  ),
        body: SafeArea(
          child: Column(
            children: [
              // Top search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.white54),
                            SizedBox(width: 8),
                            Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Stories bar with placeholders (you can keep it as is or remove)
              SizedBox(
                height: 95,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildStoryAvatar('My status', true),
                    _buildStoryAvatar('Adil', true),
                    _buildStoryAvatar('Marina', false),
                    _buildStoryAvatar('Dean', false),
                    _buildStoryAvatar('Max', true),
                  ],
                ),
              ),

              // Chat list container
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatLoaded) {
                        if (state.chats.isEmpty) {
                          return const Center(child: Text('No chats found'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: state.chats.length,
                          itemBuilder: (context, index) {
                            final chat = state.chats[index];
                            return ListTile(
                              leading: Stack(
                                children: [
                                  // Placeholder avatar: Circle with first letter of username
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.blue[300],
                                    child: Text(
                                      chat.name.isNotEmpty
                                          ? chat.name[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),

                                  // Placeholder for online status: grey circle bottom-right
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .grey, // no online info, so grey
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                chat.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                chat.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    chat.lastMessageTime,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ChatBloc>(),
                                      child: ChatDetailPage(
                                        chatId: chat.id,
                                        chatName: chat.name,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.error));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
          floatingActionButton: FloatingActionButton(
              heroTag: 'uniqueTagForThisButton',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/userList');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: const Color.fromARGB(255, 32, 86, 233),
              foregroundColor: Colors.white,
              child: const Icon(Icons.chat_bubble_outline),
            ),
      ),
    );
  }

  Widget _buildStoryAvatar(String name, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min, // prevent unnecessary overflow
        children: [
          Stack(
            children: [
              // Placeholder story avatar with first letter of name
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[300],
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: const TextStyle(color: Colors.white),
            overflow:
                TextOverflow.ellipsis, // avoid long names causing overflow
          ),
        ],
      ),
    );
  }
}
