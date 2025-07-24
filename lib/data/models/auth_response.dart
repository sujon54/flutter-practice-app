import 'package:first_flutter_app/data/models/user.dart';

class AuthResponse {
  final String? message;
  final String token;
  final User user;

  AuthResponse({this.message, required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] as String?,
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}
