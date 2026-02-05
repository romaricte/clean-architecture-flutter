import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:testapp/config/env_config.dart';
import 'package:testapp/core/network/api_client.dart';
import 'package:testapp/core/network/network_info.dart';
import 'package:testapp/core/storage/token_storage.dart';
import 'package:testapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:testapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:testapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:testapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:testapp/features/auth/domain/usecases/getReservation.dart';
import 'package:testapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_token_usecase.dart';
import 'package:testapp/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjectionContainer() async {
  sl
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: sl()),
    )
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(aOptions: AndroidOptions()),
    )
    ..registerLazySingleton<TokenStorage>(() => TokenStorageImpl(storage: sl()))
    ..registerLazySingleton<ApiClient>(
      () => ApiClient.create(
        baseUrl: EnvConfig.apiUrl,
        apiKey: EnvConfig.apiKey,
        apiToken: EnvConfig.apiToken,
        enableLogging: true,
        tokenStorage: sl(),
      ),
    )
    ..registerLazySingleton<Dio>(() => sl<ApiClient>().dio)
    // Auth
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(tokenStorage: sl()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(dio: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    )
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()))
    ..registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(sl()))
    ..registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase(sl()))
    ..registerLazySingleton<GetMeUseCase>(() => GetMeUseCase(sl()))
    ..registerLazySingleton<GetTokenUseCase>(() => GetTokenUseCase(sl()))
    ..registerLazySingleton<GetReservation>(() => GetReservation(sl()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        checkAuthUseCase: sl(),
        getMeUseCase: sl(),
        getTokenUseCase: sl(),
        getReservation: sl(),
      ),
    );
}
