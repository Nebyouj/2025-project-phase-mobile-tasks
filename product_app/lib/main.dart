import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/screens/add_update_page.dart';
import 'package:product_app/screens/details_page.dart';
import 'package:product_app/screens/home_page.dart';
import 'package:product_app/screens/search_page.dart';

void main() {
  runApp(const ShoeStoreApp());
}

class ShoeStoreApp extends StatelessWidget {
  const ShoeStoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const RootPage(),
        '/home': (context) => const HomePage(),
        '/details': (context) {
          final product = ModalRoute.of(context)?.settings.arguments;
          if (product is Product) {
            return DetailsPage(product: product);
          }
          return const HomePage(); // Fallback if no product is passed
        },
        '/search': (context) => const SearchPage(),
        '/addUpdate': (context) {
          final product = ModalRoute.of(context)?.settings.arguments;
          return AddUpdatePage(product: product as Product?);
        },
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
