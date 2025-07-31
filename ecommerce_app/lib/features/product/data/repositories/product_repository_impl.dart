import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Product>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      final products = await remoteDataSource.getAllProducts();
      await localDataSource.cacheProducts(products);
      return products;
    } else {
      return await localDataSource.getCachedProducts();
    }
  }

  @override
  Future<Product> getProduct(String id) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.getProduct(id);
    } else {
      final cachedProducts = await localDataSource.getCachedProducts();
      return cachedProducts.firstWhere((product) => product.id == id);
    }
  }

  @override
  Future<void> insertProduct(Product product) async {
    await remoteDataSource.insertProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await remoteDataSource.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }
}
