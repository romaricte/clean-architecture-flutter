import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/features/counter/domain/entities/counter.dart';
import 'package:testapp/features/counter/domain/usecases/get_counter_value.dart';
import 'package:testapp/features/counter/domain/usecases/increment_counter.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc({
    required GetCounterValueUseCase getCounterValueUseCase,
    required IncrementCounterUseCase incrementCounterUseCase,
  })  : _getCounterValueUseCase = getCounterValueUseCase,
        _incrementCounterUseCase = incrementCounterUseCase,
        super(const CounterState.initial()) {
    on<CounterStarted>(_onCounterStarted);
    on<CounterIncrementPressed>(_onCounterIncrementPressed);

    add(const CounterStarted());
  }

  final GetCounterValueUseCase _getCounterValueUseCase;
  final IncrementCounterUseCase _incrementCounterUseCase;

  void _onCounterStarted(
    CounterStarted event,
    Emitter<CounterState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
    final counter = _getCounterValueUseCase();
    emit(state.copyWith(counter: counter, isLoading: false));
  }

  void _onCounterIncrementPressed(
    CounterIncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    final counter = _incrementCounterUseCase();
    emit(state.copyWith(counter: counter));
  }
}
