import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_sources.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorage);

  @override
  Future<User> logIn(String email, String password) async {
    final result = await remoteDataSource.login(email, password);
    // print(result);
    // Save token only if present
    if (result.token != null) {
      await secureStorage.write(key: 'token', value: result.token);
    }

    // If user info is not included in login response, fetch it via /me
    UserModel? userModel = result.user;
    if (userModel == null && result.token != null) {
      final currentUserResponse = await remoteDataSource.getCurrentUser(
        result.token!,
      );
      // print('AuthRepository: User logged in with email: $email');
      userModel = currentUserResponse.user;
    }

    if (userModel == null) {
      throw Exception('Failed to retrieve user info after login');
    }
    return userModel;
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    final result = await remoteDataSource.signup(name, email, password);

    if (result.token != null) {
      await secureStorage.write(key: 'token', value: result.token);
    }

    UserModel? userModel = result.user;

    if (userModel == null) {
      throw Exception('Failed to retrieve user info after sign up');
    }

    return userModel;
  }

  @override
  Future<void> logOut() async {
    await secureStorage.delete(key: 'token');
  }

  @override
  Future<User> getCurrentUser() async {
    final token = await secureStorage.read(key: 'token');
    if (token == null) return Future.error('No token found');

    final response = await remoteDataSource.getCurrentUser(token);
    final userModel = response.user;
    if (userModel == null) {
      throw Exception('No user found in response');
    }
    await secureStorage.write(key: 'userId', value: userModel.id);
    print('AuthRepository: Current user retrieved with ID: ${userModel.id}');
    return userModel;
  }

  @override
  Future<String> getToken() async {
    final token = await secureStorage.read(key: 'token');
    if (token == null) {
      throw Exception('No token found');
    }
    return token;
  }

 
  Future<List<UserModel>> getAllUsers() async {
    final authResponseList = await remoteDataSource.getAllUsers();
    return authResponseList.map((authResponse) => authResponse.user!).toList();
  }
}
