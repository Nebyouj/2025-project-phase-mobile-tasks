import '../../domain/entities/user.dart';

class UserModel extends User {
  final String id;
  final String name;
  final String email;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  }): super(
    id: id,
    name: name,
    email: email,
    password: password,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
  );
}

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}