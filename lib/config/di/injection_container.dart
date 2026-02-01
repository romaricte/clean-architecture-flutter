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
import 'package:testapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:testapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:testapp/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:testapp/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:testapp/features/counter/domain/repositories/counter_repository.dart';
import 'package:testapp/features/counter/domain/usecases/get_counter_value.dart';
import 'package:testapp/features/counter/domain/usecases/increment_counter.dart';
import 'package:testapp/features/counter/presentation/bloc/counter_bloc.dart';

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
    ..registerLazySingleton<GetMeUseCase>(() => GetMeUseCase(sl()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(loginUseCase: sl(), getMeUseCase: sl()),
    )
    // Counter
    ..registerLazySingleton<CounterLocalDataSource>(CounterLocalDataSource.new)
    ..registerLazySingleton<CounterRepository>(
      () => CounterRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<GetCounterValueUseCase>(
      () => GetCounterValueUseCase(sl()),
    )
    ..registerLazySingleton<IncrementCounterUseCase>(
      () => IncrementCounterUseCase(sl()),
    )
    ..registerFactory<CounterBloc>(
      () => CounterBloc(
        getCounterValueUseCase: sl(),
        incrementCounterUseCase: sl(),
      ),
    );
}
