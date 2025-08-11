import 'user_model.dart';

class AuthResponseModel {
  final String? token;
  final UserModel? user;

  AuthResponseModel({this.token, this.user});

  factory AuthResponseModel.fromTokenJson(Map<String, dynamic> json) {
    return AuthResponseModel(token: json['access_token']);
  }

  factory AuthResponseModel.fromUserJson(Map<String, dynamic> json) {
    return AuthResponseModel(user: UserModel.fromJson(json));
  }
}
