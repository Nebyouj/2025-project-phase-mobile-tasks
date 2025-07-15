
// This code is a simple console-based product management system for an eCommerce application.
// It allows users to add, view, edit, and delete products with basic validation and user

import 'dart:io';

// Product Class
class Product {
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  // Getters
  String get name => _name;
  String get description => _description;
  double get price => _price;

  // Setters
  set name(String newName) => _name = newName;
  set description(String newDescription) => _description = newDescription;
  set price(double newPrice) => _price = newPrice;

  @override
  String toString() {
    return 'Name: $_name\nDescription: $_description\nPrice: \$${_price.toStringAsFixed(2)}';
  }
}

// Product Manager Class
class ProductManager {
  List<Product> _products = [];

  void addProduct() {
    stdout.write("Enter product name: ");
    String name = stdin.readLineSync()!;

    stdout.write("Enter product description: ");
    String description = stdin.readLineSync()!;

    stdout.write("Enter product price: ");
    double? price = double.tryParse(stdin.readLineSync()!);
    if (price == null || price < 0) {
      print("Invalid price. Product not added.");
      return;
    }

    _products.add(Product(name, description, price));
    print("✅ Product added successfully!\n");
  }

  void viewAllProducts() {
    if (_products.isEmpty) {
      print("⚠️ No products available.\n");
      return;
    }
    for (int i = 0; i < _products.length; i++) {
      print("📦 Product ${i + 1}:\n${_products[i]}\n");
    }
  }

  void viewSingleProduct() {
    stdout.write("Enter product index (1 to ${_products.length}): ");
    int? index = int.tryParse(stdin.readLineSync()!);
    if (index == null || index < 1 || index > _products.length) {
      print("❌ Invalid index.\n");
      return;
    }
    print("📦 Product Details:\n${_products[index - 1]}\n");
  }

  void editProduct() {
    stdout.write("Enter product index to edit: ");
    int? index = int.tryParse(stdin.readLineSync()!);
    if (index == null || index < 1 || index > _products.length) {
      print("❌ Invalid index.\n");
      return;
    }

    Product product = _products[index - 1];

    stdout.write("New name (leave empty to keep '${product.name}'): ");
    String name = stdin.readLineSync()!;
    if (name.isNotEmpty) product.name = name;

    stdout.write("New description (leave empty to keep '${product.description}'): ");
    String desc = stdin.readLineSync()!;
    if (desc.isNotEmpty) product.description = desc;

    stdout.write("New price (leave empty to keep ${product.price}): ");
    String priceInput = stdin.readLineSync()!;
    if (priceInput.isNotEmpty) {
      double? newPrice = double.tryParse(priceInput);
      if (newPrice != null && newPrice >= 0) product.price = newPrice;
    }

    print("✅ Product updated.\n");
  }

  void deleteProduct() {
    stdout.write("Enter product index to delete: ");
    int? index = int.tryParse(stdin.readLineSync()!);
    if (index == null || index < 1 || index > _products.length) {
      print("❌ Invalid index.\n");
      return;
    }

    _products.removeAt(index - 1);
    print("🗑️ Product deleted.\n");
  }
}

// Main Function
void main() {
  ProductManager manager = ProductManager();

  while (true) {
    print("🛒 eCommerce Product Manager");
    print("1. Add Product");
    print("2. View All Products");
    print("3. View Single Product");
    print("4. Edit Product");
    print("5. Delete Product");
    print("6. Exit");
    stdout.write("Choose an option: ");

    String? input = stdin.readLineSync();
    print("");

    switch (input) {
      case '1':
        manager.addProduct();
        break;
      case '2':
        manager.viewAllProducts();
        break;
      case '3':
        manager.viewSingleProduct();
        break;
      case '4':
        manager.editProduct();
        break;
      case '5':
        manager.deleteProduct();
        break;
      case '6':
        print("👋 Exiting. Goodbye!");
        return;
      default:
        print("❌ Invalid option.\n");
    }
  }
}