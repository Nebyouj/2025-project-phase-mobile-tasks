import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constants.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> signup(String name, String email, String password);
  Future<AuthResponseModel> getCurrentUser(String token);
  Future<List<AuthResponseModel>> getAllUsers();

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
Future<AuthResponseModel> login(String email, String password) async {
  final response = await client.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  
  

  if (response.statusCode == 200 || response.statusCode == 201) {
  final jsonBody = jsonDecode(response.body);

  final data = jsonBody['data'];
  // if (data == null || data is! Map<String, dynamic>) {
  //   throw Exception('Invalid login response: ${response.body}');
  // }
  
  return AuthResponseModel.fromTokenJson(data);
} else {
  throw Exception(
    'Failed to login. Status: ${response.statusCode}, Body: ${response.body}',
  );
}
}


  @override
  Future<AuthResponseModel> signup(
    String name,
    String email,
    String password,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      return AuthResponseModel.fromUserJson(jsonBody['data']);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  @override
Future<AuthResponseModel> getCurrentUser(String token) async {
  final response = await client.get(
    Uri.parse('$baseUrl/users/me'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonBody = jsonDecode(response.body);
    print('getCurrentUser response: $jsonBody'); // DEBUG

    if (jsonBody['data'] == null) {
      throw Exception('getCurrentUser data: $jsonBody'); // DEBUG
    }

    return AuthResponseModel.fromUserJson(
      jsonBody['data'] as Map<String, dynamic>,
    );
  } else {
    throw Exception('Failed to fetch user data: ${response.body}');
  }
}

@override
  Future<List<AuthResponseModel>> getAllUsers() async {
    final response = await client.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      // Map each json user to AuthResponseModel using fromUserJson
      return jsonList
          .map<AuthResponseModel>((json) => AuthResponseModel.fromUserJson(json))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

}
