import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:testapp/features/counter/presentation/bloc/counter_bloc.dart';
import 'package:testapp/features/counter/presentation/pages/counter_details_page.dart';
import 'package:testapp/features/counter/presentation/widgets/counter_controls.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  static const String routeName = 'counter';
  static const String routePath = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You have pressed the button',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '${state.counter.value}',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 24),
                const CounterControls(),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => context.goNamed(CounterDetailsPage.routeName),
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View details'),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CounterBloc>().add(const CounterIncrementPressed()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
