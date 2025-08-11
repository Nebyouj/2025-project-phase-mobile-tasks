import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import 'chat_detail_page.dart';
class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      _loaded = true;
      context.read<ChatBloc>().add(LoadUsers());  // Dispatch load users event here
    }

    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.blue[700],
    elevation: 1,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black87),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/chatList');
      },
    ),
    title: const Text('select user'),
    ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatCreated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailPage(
                  chatId: state.chat.id,
                  chatName: state.chat.name, 
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text(user.name),
                  onTap: () {
                    context.read<ChatBloc>().add(CreateChatWithUser(user.id));
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
    );
  }
}