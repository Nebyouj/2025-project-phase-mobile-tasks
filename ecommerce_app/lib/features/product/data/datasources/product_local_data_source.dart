
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<List<ProductModel>> getCachedProducts() async {
    // TODO: Retrieve from local DB or shared preferences
    throw UnimplementedError();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    // TODO: Save locally
    throw UnimplementedError();
  }
}

