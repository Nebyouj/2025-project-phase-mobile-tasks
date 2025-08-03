import 'dart:convert';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';


class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDatasourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ProductRemoteDatasourceImpl(client: mockHttpClient);
  });

  group('getAllProducts', () {
    final tProductList = [
      ProductModel(id: '1', name: 'Test Product', description: 'Desc', imageUrl: 'url', price: 10.0)
    ];

    test('should return product list when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(json.encode([tProductList[0].toJson()]), 200),
      );
      // act
      final result = await dataSource.getAllProducts();
      // assert
      expect(result, equals(tProductList));
    });

    test('should throw ServerException when the response code is not 200', () async {
      // arrange
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Error', 404));
      // act
      final call = dataSource.getAllProducts;
      // assert
      expect(() => call(), throwsA(isA<SeverExecption>()));
    });
  });
}
