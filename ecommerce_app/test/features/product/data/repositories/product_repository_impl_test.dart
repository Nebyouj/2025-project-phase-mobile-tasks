import 'package:dartz/dartz.dart';

import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:ecommerce_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late MockNetworkInfo mockNetwork;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    mockNetwork = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
      networkInfo: mockNetwork,
    );
  });

  group('getAllProducts', () {
    final tProductModel = const ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.png',
      price: 99.99,
    );
    final List<ProductModel> tProductModels = [tProductModel];
    final List<Product> tProducts = [tProductModel.toEntity()];

    test('should check if device is online', () async {
      // arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductModels);
      // act
      await repository.getAllProducts();
      // assert
      verify(mockNetwork.isConnected);
    });

    test('should return remote data when online', () async {
      // arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductModels);
      // act
      final result = await repository.getAllProducts();
      // assert
      verify(mockRemote.getAllProducts());
      expect(result, Right(tProducts));
    });

    test('should cache data locally when online', () async {
      // arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => true);
      when(mockRemote.getAllProducts()).thenAnswer((_) async => tProductModels);
      // act
      await repository.getAllProducts();
      // assert
      verify(mockLocal.cacheProducts(tProductModels));
    });

    test('should return local data when offline', () async {
      // arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProducts()).thenAnswer((_) async => tProductModels);
      // act
      final result = await repository.getAllProducts();
      // assert
      verifyZeroInteractions(mockRemote);
      verify(mockLocal.getCachedProducts());
      expect(result, Right(tProducts));
    });

    test('should return CacheFailure when no cached data', () async {
      // arrange
      when(mockNetwork.isConnected).thenAnswer((_) async => false);
      when(mockLocal.getCachedProducts()).thenThrow(CacheFailure());
      // act
      final result = await repository.getAllProducts();
      // assert
      expect(result, Left(CacheFailure()));
    });
  });
}
