import 'package:testapp/features/counter/domain/entities/counter.dart';
import 'package:testapp/features/counter/domain/repositories/counter_repository.dart';

class GetCounterValueUseCase {
  const GetCounterValueUseCase(this._repository);

  final CounterRepository _repository;

  Counter call() => _repository.getCounter();
}
