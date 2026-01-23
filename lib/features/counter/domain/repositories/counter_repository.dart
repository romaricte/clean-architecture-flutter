import 'package:testapp/features/counter/domain/entities/counter.dart';

abstract class CounterRepository {
  Counter getCounter();

  Counter increment();
}
