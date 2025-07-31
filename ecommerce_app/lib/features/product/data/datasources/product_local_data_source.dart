import '../../domain/entities/product.dart';

abstract class ProductLocalDataSource {
  Future<List<Product>> getCachedProducts();
  Future<void> cacheProducts(List<Product> products);
}
