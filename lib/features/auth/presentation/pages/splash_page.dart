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
    // On demande à récupérer l'utilisateur connecté dès le démarrage
    context.read<AuthBloc>().add(const AuthFetchMeRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (!state.isLoading) {
          if (state.user != null) {
            context.goNamed(RouteNames.home);
          } else {
            // Si on n'a pas d'utilisateur après le chargement, on va au login
            context.goNamed(RouteNames.login);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Chargement...'),
              if (context.watch<AuthBloc>().state.failure != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Erreur: ${context.watch<AuthBloc>().state.failure?.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
