class User {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final String? status;
  final List<String> roles;
  final List<String> permissions;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    this.status,
    this.roles = const [],
    this.permissions = const [],
  });
}