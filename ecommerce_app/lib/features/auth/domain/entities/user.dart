
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String password;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    password,
  ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'password': password,
    };
  }


}