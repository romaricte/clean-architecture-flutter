part of 'counter_bloc.dart';

class CounterState extends Equatable {
  const CounterState({required this.counter, required this.isLoading});

  const CounterState.initial()
      : counter = const Counter(value: 0),
        isLoading = false;

  final Counter counter;
  final bool isLoading;

  CounterState copyWith({Counter? counter, bool? isLoading}) => CounterState(
        counter: counter ?? this.counter,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [counter, isLoading];
}
