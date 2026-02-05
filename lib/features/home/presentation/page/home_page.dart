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
    context.read<AuthBloc>().add(const AuthReservationRequested());
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
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            }
            if (state.failure != null) {
              return Text(state.failure!.message);
            }
            if (state.user != null) {
              return Text('Bienvenue ${state.user!.email}');
            }
            return const Text('Accueil');
          },
        ),
      ),
    );
  }
}
