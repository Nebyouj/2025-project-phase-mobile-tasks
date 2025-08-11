import 'dart:convert';
import 'package:ecommerce_app/core/utils/constants.dart';
import 'package:ecommerce_app/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:ecommerce_app/features/auth/data/models/auth_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = AuthRemoteDataSourceImpl(mockClient);
  });

  group('AuthRemoteDataSource', () {
    const token = 'test_token';

    test('login returns AuthResponseModel on 200 response', () async {
      final responseJson = {
        'statusCode': 200,
        'message': 'Login successful',
        'data': {'token': token},
      };

      when(
        mockClient.post(
          Uri.parse('$baseUrl/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseJson), 200));

      final result = await dataSource.login('email@test.com', 'password123');

      expect(result, isA<AuthResponseModel>());
      expect(result.token, token);
    });

    test('signup returns AuthResponseModel on 201 response', () async {
      final responseJson = {
        'statusCode': 201,
        'message': 'Signup successful',
        'data': {'token': token},
      };

      when(
        mockClient.post(
          Uri.parse('$baseUrl/register'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseJson), 201));

      final result = await dataSource.signup(
        'John Doe',
        'email@test.com',
        'password123',
      );

      expect(result, isA<AuthResponseModel>());
      expect(result.token, token);
    });

    test('getCurrentUser returns AuthResponseModel on 200 response', () async {
      final responseJson = {
        'statusCode': 200,
        'message': '',
        'data': {
          '_id': '123',
          'name': 'John Doe',
          'email': 'email@test.com',
          '__v': 0,
        },
      };

      when(
        mockClient.get(
          Uri.parse('$baseUrl/user/me'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseJson), 200));

      final result = await dataSource.getCurrentUser(token);

      expect(result, isA<AuthResponseModel>());
      expect(result.user?.name, 'John Doe');
    });

    test('throws Exception when login fails', () async {
      when(
        mockClient.post(
          Uri.parse('$baseUrl/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () => dataSource.login('wrong@test.com', 'wrongpass'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
