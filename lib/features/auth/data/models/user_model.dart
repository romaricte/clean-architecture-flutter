import 'package:testapp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.phoneNumber,
    super.status,
    super.roles = const [],
    super.permissions = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      fullName: (json['full_name'] ?? '') as String,
      phoneNumber: json['phone_number'] as String?,
      status: json['status'] as String?,
      roles: (json['roles'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      permissions:
          (json['permissions'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}