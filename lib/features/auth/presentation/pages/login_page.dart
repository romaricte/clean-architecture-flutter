import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:testapp/core/errors/failures.dart';
import 'package:testapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:testapp/config/router/route_names.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.failure != current.failure ||
            (previous.user == null && current.user != null),
        listener: (context, state) {
          if (state.user != null) {
            context.goNamed(RouteNames.home);
            return;
          }

          final failure = state.failure;
          if (failure != null) {
            final message = switch (failure) {
              NoInternetFailure _ => 'Pas de connexion internet',
              // ServerFailure _ => 'Erreur serveur. Veuillez réessayer.',
              NetworkFailure _ => 'Erreur réseau. Vérifiez votre connexion.',
              ValidationFailure _ => 'Veuillez vérifier vos informations.',
              _ => failure.message,
            };
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
            return;
          }

          final message = state.errorMessage;
          if (message != null && message.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return FilledButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(
                              AuthLoginSubmitted(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                          },
                    child: state.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Se connecter'),
                  );
                },
              ),
              const SizedBox(height: 12),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final user = state.user;
                  if (user == null) return const SizedBox.shrink();

                  return Text(
                    'Connecté: ${user.fullName}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
