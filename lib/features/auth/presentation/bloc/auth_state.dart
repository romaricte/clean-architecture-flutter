part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    required this.isLoading,
    required this.user,
    required this.isAuthenticated,
    this.token,
    required this.errorMessage,
    required this.failure,
    this.reservation,
  });

  const AuthState.initial()
    : isLoading = false,
      user = null,
      isAuthenticated = false,
      token = null,
      errorMessage = null,
      reservation = null,
      failure = null;

  final bool isLoading;
  final User? user;
  final bool isAuthenticated;
  final String? token;
  final String? errorMessage;
  final Failure? failure;
  final Map<String, dynamic>? reservation;

  AuthState copyWith({
    bool? isLoading,
    User? user,
    bool? isAuthenticated,
    String? token,
    String? errorMessage,
    Failure? failure,
    Map<String, dynamic>? reservation,  
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      errorMessage: errorMessage,
      failure: failure,
      reservation: reservation ?? this.reservation,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    user,
    isAuthenticated,
    token,
    errorMessage,
    failure,
    reservation,

  ];
}
