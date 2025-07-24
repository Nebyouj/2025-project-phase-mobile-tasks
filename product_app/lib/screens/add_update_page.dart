import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/product_data.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product;

  const AddUpdatePage({super.key, this.product});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool get isUpdate => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isUpdate) {
      _nameController.text = widget.product!.name;
      _categoryController.text = widget.product!.category;
      _priceController.text = widget.product!.price.toString();
      _ratingController.text = widget.product!.rating.toString();
      _descriptionController.text = widget.product!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void saveProduct() {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final rating = double.tryParse(_ratingController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();
    final imageURL = _nameController.text.trim();

    if (name.isEmpty ||
        category.isEmpty ||
        price <= 0 ||
        rating <= 0 ||
        description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields properly.")),
      );
      return;
    }

    final newProduct = Product(
      name: name,
      category: category,
      price: price,
      rating: rating,
      description: description,
      imageUrl: imageURL,
    );

    if (isUpdate) {
      // Update product in list
      final index = products.indexOf(widget.product!);
      if (index != -1) {
        products[index] = newProduct;
        debugPrint("Updated: ${newProduct.name}");
      }
    } else {
      // Add new product
      products.add(newProduct);
      debugPrint("Added: ${newProduct.name}");
    }

    Navigator.pop(context);
  }

  void deleteProduct() {
    if (isUpdate) {
      products.remove(widget.product);
      debugPrint("Deleted: ${widget.product!.name}");
    }
    Navigator.pop(context);
  }

  Widget buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? 'Update Product' : 'Add Product',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Upload image placeholder
              buildTextField("Image URL", _imageUrlController),
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, size: 40),
                      const SizedBox(height: 8),
                      const Text(
                        "upload image",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input fields
              buildTextField("Name", _nameController),
              buildTextField("Category", _categoryController),
              buildTextField(
                "Price",
                _priceController,
                inputType: TextInputType.number,
              ),
              buildTextField(
                "Rating",
                _ratingController,
                inputType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Add/Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B5BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isUpdate ? "UPDATE" : "ADD",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Delete Button (only in update mode)
              if (isUpdate)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: deleteProduct,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "DELETE",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class AddUpdatePage extends StatelessWidget {
//   const AddUpdatePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         leading: Icon(Icons.arrow_back, color: Colors.black),
//         title: const Text(
//           'Add Product',
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),

//               // Upload image box
//               Container(
//                 height: 140,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.image, size: 40),
//                       SizedBox(height: 8),
//                       Text("upload image", style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Name
//               buildTextField("name"),

//               // Category
//               buildTextField("category"),

//               // Price with $ icon
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "price",
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   suffixIcon: const Padding(
//                     padding: EdgeInsets.only(top: 15, right: 15),
//                     child: Text(
//                       "\$",
//                       style: TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),

//               const SizedBox(height: 16),

//               // Description
//               TextField(
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   hintText: "description",
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Add Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF3B5BFF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text(
//                     "ADD",
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Delete Button
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () {},
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: Colors.red),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child: const Text(
//                     "DELETE",
//                     style: TextStyle(color: Colors.red, fontSize: 16),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(String hint) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: hint,
//           filled: true,
//           fillColor: Colors.grey[200],
//           border: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     );
//   }
// }
