import 'package:testapp/features/counter/domain/entities/counter.dart';
import 'package:testapp/features/counter/domain/repositories/counter_repository.dart';

class IncrementCounterUseCase {
  const IncrementCounterUseCase(this._repository);

  final CounterRepository _repository;

  Counter call() => _repository.increment();
}
