import 'package:flutter/material.dart';

import '../../data/datasources/product_data.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';
import 'details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> filteredProducts = [];
  String searchQuery = '';
  String categoryFilter = '';
  RangeValues priceRange = const RangeValues(0, 1000);

  @override
  void initState() {
    super.initState();
    filteredProducts = products; // productList comes from product_list.dart
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesQuery =
            product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            product.name.toLowerCase().contains(searchQuery.toLowerCase());

        final matchesCategory =
            categoryFilter.isEmpty ||
            product.name.toLowerCase().contains(
              categoryFilter.toLowerCase(),
            );

        final matchesPrice =
            product.price >= priceRange.start &&
            product.price <= priceRange.end;

        return matchesQuery && matchesCategory && matchesPrice;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    searchQuery = value;
    _filterProducts();
  }

  void _showFilterSheet() {
    String selectedCategory = categoryFilter;
    RangeValues selectedPrice = priceRange;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Category'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: selectedCategory),
                    onChanged: (value) {
                      setModalState(() => selectedCategory = value);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Price'),
                  RangeSlider(
                    values: selectedPrice,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      selectedPrice.start.toStringAsFixed(0),
                      selectedPrice.end.toStringAsFixed(0),
                    ),
                    onChanged: (RangeValues values) {
                      setModalState(() => selectedPrice = values);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // ✅ Update real state and apply filter
                      setState(() {
                        categoryFilter = selectedCategory;
                        priceRange = selectedPrice;
                      });
                      _filterProducts();
                      Navigator.pop(context);
                    },
                    child: const Text('APPLY'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by name or category...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),

                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 10),
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
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors
                                    .blue; // Background turns blue when pressed
                              }
                              return Colors.white;
                            },
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith<Color>((
                            states,
                          ) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors
                                  .white; // Icon turns white when button is pressed
                            }
                            return Colors.black; // Default icon color
                          }),
                        ),
                    onPressed: _showFilterSheet,
                    child: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
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
    );
  }
}
