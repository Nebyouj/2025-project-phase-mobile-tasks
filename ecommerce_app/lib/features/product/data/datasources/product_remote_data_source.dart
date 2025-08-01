
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProduct(String id);
  Future<void> insertProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getAllProducts() async {
    // TODO: API call
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> insertProduct(ProductModel product) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String id) async {
    throw UnimplementedError();
  }
}
