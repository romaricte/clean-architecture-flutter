import 'package:testapp/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final String accessToken;
  final UserModel user;

  LoginResponseModel({required this.accessToken, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Structure expected: {"session": {"access_token": "..."}, "user": {...}}
    // Note: UserModel.fromJson will parse from the root if it contains the user fields
    // or we might need to adjust based on the exact API response.
    // Based on the terminal log: {"session": {...}, "user": {...}}

    final session = json['session'] as Map<String, dynamic>;
    final userJson = json['user'] as Map<String, dynamic>;

    return LoginResponseModel(
      accessToken: session['access_token'] as String,
      user: UserModel.fromJson(userJson),
    );
  }
}
