
import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

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
  Future<Either<Failures, List<Product>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getAllProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure());
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return Right(localProducts.map((model) => model.toEntity()).toList());
      } on CacheException {
        return Left(CacheFailure());
      } catch (_) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failures, Product>> getProduct(String id) async {
    try {
      final product = await remoteDataSource.getProduct(id);
      return Right(product.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failures, void>> insertProduct(Product product) async {
    try {
      await remoteDataSource.insertProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failures, void>> updateProduct(Product product) async {
    try {
      await remoteDataSource.updateProduct(ProductModel.fromEntity(product));
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failures, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
