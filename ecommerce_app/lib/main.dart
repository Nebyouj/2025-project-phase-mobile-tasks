import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/chats/domain/repositories/chat_repository.dart';
import 'features/chats/presentation/bloc/chat_bloc.dart';
import 'features/chats/presentation/bloc/chat_event.dart';
import 'features/chats/presentation/pages/chat_list_page.dart';
import 'features/chats/presentation/pages/user_list_page.dart';
import 'features/product/domain/entities/product.dart';
import 'features/product/presentation/screens/add_update_page.dart';
import 'features/product/presentation/screens/details_page.dart';
import 'features/product/presentation/screens/home_page.dart';
import 'features/product/presentation/screens/search_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  const ShoeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider<ChatRepository>(create: (_) => di.sl<ChatRepository>()),
        Provider<AuthRepository>(create: (_) => di.sl<AuthRepository>()),
        BlocProvider(create: (_) => di.sl<ChatBloc>()..add(LoadChats())),
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
      ],
      child: MaterialApp(
        title: 'Shoe Store',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          Widget page;

          switch (settings.name) {
            case '/':
              page = const SplashScreen();
              break;
            case '/home':
              page = const HomePage();
              break;
            case '/details':
              final product = settings.arguments;
              if (product is Product) {
                page = DetailsPage(product: product);
              } else {
                page = const HomePage();
              }
              break;
            case '/search':
              page = const SearchPage();
              break;
            case '/addUpdate':
              final product = settings.arguments;
              page = AddUpdatePage(product: product as Product?);
              break;
            case '/chatList':
              page = const ChatListPage();
              break;
            case '/userList':
              page = const UserListPage();
              break;
            default:
              page = const HomePage();
          }

          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: const [HomePage(), SearchPage(), ChatListPage()],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        selectedIndex: currentPage,
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:product_app/screens/add_update_page.dart';
// import 'package:product_app/screens/home_page.dart';
// import 'package:product_app/screens/search_page.dart';

// void main() {
//   runApp(ShoeStoreApp());
// }

// class ShoeStoreApp extends StatelessWidget {
//   const ShoeStoreApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Shoe Store',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       debugShowCheckedModeBanner: false,
//       home: const RootPage(),
//     );
//   }
// }

// class RootPage extends StatefulWidget {
//   const RootPage({super.key});

//   @override
//   State<RootPage> createState() => _RootPageState();
// }

// class _RootPageState extends State<RootPage> {
//   int currentPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: currentPage,
//         children: const [
//           HomePage(),
//           SearchPage(),
//           AddUpdatePage(),
//         ],
//       ),
//       bottomNavigationBar: NavigationBar(
//         destinations: [
//           NavigationDestination(icon: const Icon(Icons.home), label: 'Home'),
//           NavigationDestination(
//             icon: const Icon(Icons.search),
//             label: 'Search',
//           ),
//           NavigationDestination(
//             icon: const Icon(Icons.person),
//             label: 'Add/Update',
//           ),
//         ],
//         onDestinationSelected: (int index) {
//           setState(() {
//             currentPage = index;
//           });
//         },
//         selectedIndex: currentPage,
//       ),
//     );
//   }
// }
