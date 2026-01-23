import 'package:equatable/equatable.dart';

class Counter extends Equatable {
  const Counter({required this.value});

  final int value;

  Counter copyWith({int? value}) => Counter(value: value ?? this.value);

  @override
  List<Object?> get props => [value];
}
