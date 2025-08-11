import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ProductRemoteDataSource>(),
  MockSpec<ProductLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemote;
  late MockProductLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockProductRemoteDataSource();
    mockLocal = MockProductLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  final tProductModel = const ProductModel(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    imageUrl: 'https://example.com/image.png',
    price: 99.99,
  );
  final List<ProductModel> tProductModels = [tProductModel];
  final List<Product> tProducts = [tProductModel.toEntity()];

  group('getAllProducts', () {
    test('should check if device is online', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductModels);

      await repository.getAllProducts();

      verify(mockNetwork.isConnected);
    });

    test('should return remote data when online', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductModels);

      final result = await repository.getAllProducts();

      verify(mockRemote.getAllProducts());
      expect(result, equals(Right(tProducts)));

    });

    test('should cache data locally when online', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductModels);

      await repository.getAllProducts();

      verify(mockLocal.cacheProducts(tProductModels));
    });

    test('should return local data when offline', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProducts()).thenAnswer((_) async => tProductModels);

      final result = await repository.getAllProducts();

      verifyZeroInteractions(mockRemote);
      verify(mockLocal.getCachedProducts());
      expect(result, equals(Right<Failures, List<Product>>(tProducts)));

    });

    test('should return CacheFailure when no cached data', () async {
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProducts()).thenThrow(CacheException());

      final result = await repository.getAllProducts();

      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('getProduct', () {
    test('should return product when found', () async {
      when(mockRemote.getProduct('1')).thenAnswer((_) async => tProductModel);

      final result = await repository.getProduct('1');

      verify(mockRemote.getProduct('1'));
      expect(result, equals(Right(tProductModel.toEntity())));
    });

    test('should return ServerFailure when an error occurs', () async {
      when(mockRemote.getProduct('1')).thenThrow(ServerException());

      final result = await repository.getProduct('1');

      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('insertProduct', () {
    final productEntity = tProductModel.toEntity();

    test('should insert product successfully', () async {
      when(mockRemote.insertProduct(any)).thenAnswer((_) async => Future.value());

      final result = await repository.insertProduct(productEntity);

      verify(mockRemote.insertProduct(any));
      expect(result, equals(const Right(null)));
    });

    test('should return ServerFailure on error', () async {
      when(mockRemote.insertProduct(any)).thenThrow(ServerException());

      final result = await repository.insertProduct(productEntity);

      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('updateProduct', () {
    final productEntity = tProductModel.toEntity();

    test('should update product successfully', () async {
      when(mockRemote.updateProduct(any)).thenAnswer((_) async => Future.value());

      final result = await repository.updateProduct(productEntity);

      verify(mockRemote.updateProduct(any));
      expect(result, equals(const Right(null)));
    });

    test('should return ServerFailure on error', () async {
      when(mockRemote.updateProduct(any)).thenThrow(ServerException());

      final result = await repository.updateProduct(productEntity);

      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('deleteProduct', () {
    test('should delete product successfully', () async {
      when(mockRemote.deleteProduct('1')).thenAnswer((_) async => Future.value());

      final result = await repository.deleteProduct('1');

      verify(mockRemote.deleteProduct('1'));
      expect(result, equals(const Right(null)));
    });

    test('should return ServerFailure on error', () async {
      when(mockRemote.deleteProduct('1')).thenThrow(ServerException());

      final result = await repository.deleteProduct('1');

      expect(result, equals(Left(ServerFailure())));
    });
  });
}
