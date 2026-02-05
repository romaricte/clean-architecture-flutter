import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:testapp/config/router/route_names.dart';
import 'package:testapp/features/auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // On demande uniquement à vérifier la présence du token au démarrage
    context.read<AuthBloc>().add(const AuthCheckRequested());

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!state.isLoading) {
          print('SplashPage: state.isAuthenticated: ${state.isAuthenticated}');
          print('SplashPage: state.token: ${state.token}');
          if (state.token != null) {
            GoRouter.of(context).goNamed(RouteNames.home);
          } else if (state.failure == null && state.errorMessage == null) {
            // Uniquement si on n'a pas de token et aucune erreur
           GoRouter.of(context).goNamed(RouteNames.login);
          }
          // Si state.failure != null, on reste sur la SplashPage pour afficher l'erreur
        //  context.goNamed(RouteNames.login);
        }
      },
      child: Scaffold(
        body: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
             return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // 1. On n'affiche le chargement QUE si state.isLoading est vrai
      if (state.isLoading) ...[
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text('Chargement..rrrrrrrrrrrrr.'),
      ],
      // 2. On affiche l'erreur si elle existe pour comprendre pourquoi ça bloque
      if (state.errorMessage != null || state.failure != null) ...[
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 16),
        Text(
          'Erreur détectée: ${state.failure?.message ?? state.errorMessage}',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.read<AuthBloc>().add(const AuthCheckRequested()),
          child: const Text('Réessayer'),
        ),
      ],
    ],
  
            );
            },
          ),
        ),
      ),
    );
  }
}
