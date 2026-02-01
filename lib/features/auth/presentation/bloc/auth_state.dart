part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.isLoading,
    required this.user,
    required this.errorMessage,
    required this.failure,
  });

  const AuthState.initial()
      : isLoading = false,
        user = null,
        errorMessage = null,
        failure = null;

  final bool isLoading;
  final User? user;
  final String? errorMessage;
  final Failure? failure;

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? errorMessage,
    Failure? failure,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, errorMessage, failure];
}
