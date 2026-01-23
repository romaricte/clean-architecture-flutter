import 'package:testapp/features/counter/data/datasources/counter_local_data_source.dart';
import 'package:testapp/features/counter/data/repositories/counter_repository_impl.dart';
import 'package:testapp/features/counter/domain/repositories/counter_repository.dart';
import 'package:testapp/features/counter/domain/usecases/get_counter_value.dart';
import 'package:testapp/features/counter/domain/usecases/increment_counter.dart';

class DependencyProvider {
  DependencyProvider._();

  static final CounterLocalDataSource _counterLocalDataSource = CounterLocalDataSource();

  static final CounterRepository counterRepository =
      CounterRepositoryImpl(localDataSource: _counterLocalDataSource);

  static final GetCounterValueUseCase getCounterValueUseCase =
      GetCounterValueUseCase(counterRepository);

  static final IncrementCounterUseCase incrementCounterUseCase =
      IncrementCounterUseCase(counterRepository);
}
