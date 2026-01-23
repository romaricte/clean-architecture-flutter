import 'package:testapp/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:testapp/features/counter/domain/entities/counter.dart';
import 'package:testapp/features/counter/domain/repositories/counter_repository.dart';

class CounterRepositoryImpl implements CounterRepository {
  CounterRepositoryImpl({required CounterLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  final CounterLocalDataSource _localDataSource;

  @override
  Counter getCounter() => Counter(value: _localDataSource.getCounter());

  @override
  Counter increment() => Counter(value: _localDataSource.increment());
}
