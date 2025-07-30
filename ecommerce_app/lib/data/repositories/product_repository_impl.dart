import 'package:uuid/uuid.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [];

  @override
  Future<void> insertProduct(Product product) async {
    final newproduct = product.copyWith(id: const Uuid().v4());
    _products.add(newproduct);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products.removeAt(index);
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    return _products.firstWhere(
      (product) => product.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  @override
  Future<List<Product>> getAllProducts() async {
    return _products;
  }
}
