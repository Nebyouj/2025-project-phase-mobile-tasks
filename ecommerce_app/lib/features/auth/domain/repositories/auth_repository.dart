import '../entities/user.dart';

abstract class AuthRepository {
  Future<void> logOut();
  Future<User> logIn(String username, String password);
  Future<User> signUp(String email, String name, String password);
  Future<User> getCurrentUser();
  Future<String> getToken();
}