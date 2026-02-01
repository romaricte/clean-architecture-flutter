import 'package:testapp/core/storage/token_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorage _tokenStorage;

  AuthLocalDataSourceImpl({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  @override
  Future<void> saveToken(String token) async {
    await _tokenStorage.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return _tokenStorage.getToken();
  }

  @override
  Future<void> clearToken() async {
    await _tokenStorage.clearToken();
  }
}
