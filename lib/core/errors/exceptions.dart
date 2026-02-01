class ServerException implements Exception {
  const ServerException(this.message);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;
}

class NoInternetException implements Exception {
  const NoInternetException(this.message);
  final String message;
}

class CacheException implements Exception {
  const CacheException(this.message);
  final String message;
}

class ParseException implements Exception {
  const ParseException(this.message);
  final String message;
}