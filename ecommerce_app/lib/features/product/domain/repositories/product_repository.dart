
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failures, List<Product>>> getAllProducts();
  Future<Either<Failures, Product>> getProduct(String id);
  Future<Either<Failures, void>> insertProduct(Product product);
  Future<Either<Failures, void>> updateProduct(Product product);
  Future<Either<Failures, void>> deleteProduct(String id);
}
