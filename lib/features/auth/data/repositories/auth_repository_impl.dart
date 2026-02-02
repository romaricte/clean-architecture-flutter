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
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      throw const NoInternetFailure('No internet connection');
    }
    try {
      return await _remoteDataSource.getMe();
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
  Future<void> logout() async {
    await _localDataSource.clearToken();
  }
}
