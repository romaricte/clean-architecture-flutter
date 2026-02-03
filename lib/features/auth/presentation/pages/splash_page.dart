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
          } else if (state.failure == null && state.errorMessage == null) {
            // Uniquement si on n'a pas d'utilisateur et aucune erreur (fin normale sans auth)
            context.goNamed(RouteNames.login);
          }
          // Si state.failure != null, on reste sur la SplashPage pour afficher l'erreur
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
              if (context.watch<AuthBloc>().state.failure != null ||
                  context.watch<AuthBloc>().state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Text(
                        'Erreur: ${context.watch<AuthBloc>().state.failure?.message ?? context.watch<AuthBloc>().state.errorMessage}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            const AuthFetchMeRequested(),
                          );
                        },
                        child: const Text('Réessayer'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          context.goNamed(RouteNames.login);
                        },
                        child: const Text('Aller au login'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
