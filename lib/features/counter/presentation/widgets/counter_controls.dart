import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/features/counter/presentation/bloc/counter_bloc.dart';

class CounterControls extends StatelessWidget {
  const CounterControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton(
          onPressed: () => context.read<CounterBloc>().add(const CounterIncrementPressed()),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
