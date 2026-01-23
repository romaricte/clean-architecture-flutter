import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testapp/config/router/app_router.dart';
import 'package:testapp/core/theme/app_theme.dart';
import 'package:testapp/config/di/dependency_provider.dart';
import 'package:testapp/features/counter/presentation/bloc/counter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (_) => CounterBloc(
            getCounterValueUseCase: DependencyProvider.getCounterValueUseCase,
            incrementCounterUseCase: DependencyProvider.incrementCounterUseCase,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'TestApp',
        theme: AppTheme.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
