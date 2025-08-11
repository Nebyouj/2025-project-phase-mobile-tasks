import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import '../../../auth/domain/entities/auth_status.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import '../../../chats/domain/repositories/chat_repository.dart';
import '../../data/datasources/product_data.dart';
import '../widgets/product_card.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.isAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          String userName = state.user?.name ?? 'Guest';
          return Scaffold(
            backgroundColor: const Color(0xffF5F5F5),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(137, 98, 93, 93),
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            Text(
                              'Hello, $userName',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications_none),
                        ElevatedButton(
                          onPressed: () async {
                            context.read<AuthBloc>().add(LogoutRequested());
                            await context.read<ChatRepository>().disconnectSocket();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInPage(),
                              ),
                            );
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Text(
                          'Available products',
                          style: TextStyle(
                            fontSize: 24,

                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 48,
                          width: 48,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Colors.blue, // Icon color when pressed
                                  shadowColor: Colors.blueAccent,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(color: Colors.black),
                                  ),
                                ).copyWith(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>((
                                        states,
                                      ) {
                                        if (states.contains(
                                          WidgetState.pressed,
                                        )) {
                                          return Colors
                                              .blue; // Background turns blue when pressed
                                        }
                                        return Colors.white;
                                      }),
                                ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/search');
                            },
                            child: const Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(product: products[index]),
                                  ),
                                );
                              },
                              child: ProductCard(product: products[index]),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addUpdate');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: const Color.fromARGB(255, 32, 86, 233),
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
