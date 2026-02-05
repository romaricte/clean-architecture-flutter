import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class TokenStorageImpl implements TokenStorage {
  TokenStorageImpl({required FlutterSecureStorage storage})
    : _storage = storage;

  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    print(
      'TokenStorage: Sauvegarde du token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...',
    );
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    print('TokenStorage: [DEBUG] Début de la lecture du stockage...'); // Ajoute ceci

try {
    final token = await _storage.read(key: _tokenKey);
    print(
      'TokenStorage: Récupération du token: ${token != null ? 'Présent' : 'Absent'}',
    );
    return token;
} catch (e) {
    print('TokenStorage: [DEBUG] Erreur lors de la lecture du stockage: $e'); // Ajoute ceci
    return null;
}
  }

  @override
  Future<void> clearToken() async {
    print('TokenStorage: Suppression du token');
    await _storage.delete(key: _tokenKey);
  }
}
