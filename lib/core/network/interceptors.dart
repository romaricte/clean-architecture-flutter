
import 'package:dio/dio.dart';
import 'package:testapp/core/storage/token_storage.dart';

List<Interceptor> buildDefaultInterceptors({
  required String apiKey,
  required String apiToken,
  required bool enableLogging,
  TokenStorage? tokenStorage,
}) {
  final interceptors = <Interceptor>[];

  interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (apiKey.isNotEmpty) {
          options.headers['X-API-KEY'] = apiKey;
        }
        if (apiToken.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $apiToken';
        }
        // Ajouter le token stocké (s’il existe) en priorité sur apiToken
        if (tokenStorage != null) {
          final storedToken = await tokenStorage.getToken();
          if (storedToken != null && storedToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $storedToken';
          }
        }
        handler.next(options);
      },
    ),
  );

  if (enableLogging) {
    interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  return interceptors;
}
