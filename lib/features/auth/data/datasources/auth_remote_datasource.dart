import 'package:dio/dio.dart';
import 'package:testapp/config/env_config.dart';
import 'package:testapp/core/constants/api_endpoints.dart';
import 'package:testapp/core/errors/exceptions.dart';
import 'package:testapp/features/auth/data/models/login_response_model.dart';
import 'package:testapp/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        options: Options(
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      final data = response.data;
      if (data == null) {
        throw const ParseException('Empty response');
      }

      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> getMe() async {
    try {
      print('DEBUG: Calling getMe at ${ApiEndpoints.me}');
      final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);

      final data = response.data;
      if (data == null) {
        throw const ParseException('Empty response');
      }

      print('DEBUG: getMe response: $data');

      // Si la réponse contient une clé 'user', on extrait le contenu
      if (data.containsKey('user') && data['user'] is Map<String, dynamic>) {
        return UserModel.fromJson(data['user'] as Map<String, dynamic>);
      }

      return UserModel.fromJson(data);
    } on DioException catch (e) {
      print('DEBUG: getMe DioException: ${e.message}');
      throw _handleDioError(e);
    } catch (e) {
      print('DEBUG: getMe Exception: $e');
      rethrow;
    }
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = _extractErrorMessage(e);
    print('Error: $message');
    if (statusCode == null) {
      return NetworkException(message);
    } else if (statusCode >= 500) {
      return ServerException('Server error ($statusCode): $message');
    } else if (statusCode == 401) {
      return ServerException('Unauthorized: $message');
    } else if (statusCode >= 400) {
      return ServerException('Client error ($statusCode): $message');
    } else {
      return NetworkException('API error ($statusCode): $message');
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
      final error = data['error'];
      if (error is String && error.isNotEmpty) return error;
    }

    if (e.message != null && e.message!.isNotEmpty) {
      return e.message!;
    }

    return 'Network error. API_URL=${EnvConfig.apiUrl}';
  }
}
