import 'dart:convert';

import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  final tProductModel = const ProductModel(
    id: '1',
    name: 'Test Product',
    catogory: 'Test catogory',
    rating: 5.0,
    description: 'Test Desc',
    imageUrl: 'https://example.com/img.png',
    price: 99.99,
  );
  final tProductList = [tProductModel];

  group('getCachedProducts', () {
    test('should return List<ProductModel> from SharedPreferences when present', () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(json.encode([tProductModel.toJson()]));
      // act
      final result = await dataSource.getCachedProducts();
      // assert
      expect(result, equals(tProductList));
    });

    test('should throw CacheException when no cached data is present', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = dataSource.getCachedProducts;
      // assert
      expect(() => call(), throwsA(isA<CacheExecption>()));
    });
  });

  group('cacheProducts', () {
    test('should call SharedPreferences to cache data', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      await dataSource.cacheProducts(tProductList);
      // assert
      verify(mockSharedPreferences.setString(
        cachedProducts,
        json.encode([tProductModel.toJson()]),
      ));
    });
  });
}
