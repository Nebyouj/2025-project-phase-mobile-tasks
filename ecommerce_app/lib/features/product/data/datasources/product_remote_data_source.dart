import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(String id);
  Future<void> insertProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
