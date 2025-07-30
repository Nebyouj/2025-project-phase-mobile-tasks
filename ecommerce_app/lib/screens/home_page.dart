import 'package:flutter/material.dart';
import '../models/product_data.dart';
import 'details_page.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'July 25, 2025',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(137, 98, 93, 93),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Hello, Nebyou',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications_none),
                ],
              ),
              const SizedBox(height: 40),
              Row(children: [
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue, // Icon color when pressed
                      shadowColor: Colors.blueAccent,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.blue; // Background turns blue when pressed
                          }
                          return Colors.white;
                        },
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    }, child: const Icon(Icons.search, color: Colors.black, size: 24),
                  ),
                )
                
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
                        onTap: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(product: products[index]),
                            ),
                          );
                        },
                        child: ProductCard(product: products[index]),
                      ),
                    );
                  },
                )
              )
            ],
          ),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addUpdate');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: const Color.fromARGB(255, 32, 86, 233),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    
    );
  }
}
