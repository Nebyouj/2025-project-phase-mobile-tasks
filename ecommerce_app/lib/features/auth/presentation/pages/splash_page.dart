import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../chats/domain/repositories/chat_repository.dart';
import '../../domain/entities/auth_status.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'sign_in_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AppStarted());

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.status == AuthStatus.isAuthenticated) {
            final chatRepo = context.read<ChatRepository>();
            final token = await context.read<AuthBloc>().getToken();

            await chatRepo.connectSocket(token);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RootPage()),
            );
          } else if (state.status == AuthStatus.unauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignInPage()),
            );
          }
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
