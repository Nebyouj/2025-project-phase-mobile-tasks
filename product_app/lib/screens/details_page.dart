import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';

class DetailsPage extends StatefulWidget {
  final Product product;

  const DetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int? selectedSize;
  bool isSwitched = false;

  final List<int> sizes = [39, 40, 41, 42, 43, 44];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.product.name} Details")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Full width image
            SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.network(widget.product.imageUrl, fit: BoxFit.cover),
            ),

            // 🔽 Content below the image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.category,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(
                        '${widget.product.rating}',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text('\$${widget.product.price}', style: const TextStyle(fontSize: 25)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Size", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                          foregroundColor: isSelected ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Text(size.toString()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.product.description),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                     
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSwitched ? Colors.red : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isSwitched = !isSwitched;
                            });
                          },
                          child: const Text("Delete"),
                        ),
                        const SizedBox(width: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/addUpdate',
                              arguments: widget.product,
                            );
                          },
                          child: const Text("Update"),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
