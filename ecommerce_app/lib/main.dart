import 'package:flutter/material.dart';
import 'features/product/domain/entities/product.dart';
import 'features/product/presentation/screens/add_update_page.dart';
import 'features/product/presentation/screens/details_page.dart';
import 'features/product/presentation/screens/home_page.dart';
import 'features/product/presentation/screens/search_page.dart';

void main() {
  runApp(const ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  const ShoeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Shoe Store',
  theme: ThemeData(primarySwatch: Colors.blue),
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  onGenerateRoute: (settings) {
    Widget page;

    switch (settings.name) {
      case '/':
        page = const RootPage();
        break;
      case '/home':
        page = const HomePage();
        break;
      case '/details':
        final product = settings.arguments;
        if (product is Product) {
          page = DetailsPage(product: product);
        } else {
          page = const HomePage(); // fallback
        }
        break;
      case '/search':
        page = const SearchPage();
        break;
      case '/addUpdate':
        final product = settings.arguments;
        page = AddUpdatePage(product: product as Product?);
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
        children: const [
          HomePage(),
          SearchPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
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
