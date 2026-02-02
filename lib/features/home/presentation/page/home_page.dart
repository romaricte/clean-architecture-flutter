import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:testapp/config/router/route_names.dart';
import 'package:testapp/features/auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Lancer la requête pour récupérer les infos de l'utilisateur
    context.read<AuthBloc>().add(const AuthFetchMeRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.user == null && !state.isLoading) {
            context.goNamed(RouteNames.login);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = state.user;
            if (user == null) {
              return const Center(child: Text('Aucun utilisateur trouvé'));
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenue, ${user.fullName} !',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(user.email),
                  const SizedBox(height: 24),
                  if (user.roles.isNotEmpty) ...[
                    Text(
                      'Rôles:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(user.roles.join(', ')),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
