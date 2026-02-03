import 'package:testapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:testapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:testapp/core/network/network_info.dart';
import 'package:testapp/core/errors/exceptions.dart';
import 'package:testapp/core/errors/failures.dart';
import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<User> login({required String email, required String password}) async {
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      throw const NoInternetFailure('No internet connection');
    }
    try {
      final loginResponse = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Sauvegarde du token dans la couche Depôt (Repository)
      await _localDataSource.saveToken(loginResponse.accessToken);

      return loginResponse.user;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ParseException catch (e) {
      throw NetworkFailure(e.message);
    } on NoInternetException catch (e) {
      throw NoInternetFailure(e.message);
    } on CacheException catch (e) {
      throw CacheFailure(e.message);
    }
  }

  @override
  Future<User> getMe() async {
    print('DEBUG: AuthRepository.getMe() called');
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      print('DEBUG: AuthRepository.getMe() - No connection');
      throw const NoInternetFailure('No internet connection');
    }
    try {
      final user = await _remoteDataSource.getMe();
      print('DEBUG: AuthRepository.getMe() - Success: ${user.fullName}');
      return user;
    } on ServerException catch (e) {
      print('DEBUG: AuthRepository.getMe() - ServerException: ${e.message}');
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      print('DEBUG: AuthRepository.getMe() - NetworkException: ${e.message}');
      throw NetworkFailure(e.message);
    } on ParseException catch (e) {
      print('DEBUG: AuthRepository.getMe() - ParseException: ${e.message}');
      throw NetworkFailure(e.message);
    } on NoInternetException catch (e) {
      print(
        'DEBUG: AuthRepository.getMe() - NoInternetException: ${e.message}',
      );
      throw NoInternetFailure(e.message);
    } on CacheException catch (e) {
      print('DEBUG: AuthRepository.getMe() - CacheException: ${e.message}');
      throw CacheFailure(e.message);
    } catch (e) {
      print('DEBUG: AuthRepository.getMe() - Unknown Error: $e');
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getToken();
    print(
      'DEBUG: AuthRepository.isAuthenticated() - token prefix: ${token != null && token.isNotEmpty ? token.substring(0, (token.length > 5 ? 5 : token.length)) : 'null/empty'}',
    );
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    print('DEBUG: AuthRepository.logout() called');
    await _localDataSource.clearToken();
  }
}
