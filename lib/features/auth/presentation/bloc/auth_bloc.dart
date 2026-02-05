import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/core/errors/failures.dart';
import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/usecases/getReservation.dart';
import 'package:testapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_token_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthUseCase checkAuthUseCase,
    required GetMeUseCase getMeUseCase,
    required GetTokenUseCase getTokenUseCase,
    required GetReservation getReservation,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _checkAuthUseCase = checkAuthUseCase,
       _getMeUseCase = getMeUseCase,
       _getTokenUseCase = getTokenUseCase,
       _getReservation = getReservation,
       super(const AuthState.initial()) {
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthFetchMeRequested>(_onAuthFetchMeRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthReservationRequested>(_onAuthReservationRequested);
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthUseCase _checkAuthUseCase;
  final GetMeUseCase _getMeUseCase;
  final GetTokenUseCase _getTokenUseCase;
  final GetReservation _getReservation;


  Future<void> _onAuthReservationRequested(
    AuthReservationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, failure: null));
    try {
      final reservation = await _getReservation.call();
      emit(
        state.copyWith(
          isLoading: false,
          reservation: reservation,
          errorMessage: null,
          failure: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          failure: null,
        ),
      );
    }
  }
  Future<void> _onAuthLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, failure: null));

    try {
      final user = await _loginUseCase(
        email: event.email,
        password: event.password,
      );

      // Récupérer le token qui vient d'être sauvegardé pour mettre à jour l'état
      final token = await _getTokenUseCase();

      emit(
        state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
          token: token,
          errorMessage: null,
          failure: null,
        ),
      );
    } on Failure catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: null, failure: e));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          failure: null,
        ),
      );
    }
  }

  Future<void> _onAuthFetchMeRequested(
    AuthFetchMeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, failure: null));

    try {
      final authenticated = await _checkAuthUseCase();

      if (authenticated) {
        final user = await _getMeUseCase();
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            errorMessage: null,
            failure: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            user: null,
            isAuthenticated: false,
            errorMessage: null,
            failure: null,
          ),
        );
      }
    } on Failure catch (e) {
      // On ne déconnecte que si c'est une erreur d'autorisation (401)
      final bool isAuthError = e.message.toLowerCase().contains('unauthorized');

      emit(
        state.copyWith(
          isLoading: false,
          user: null,
          isAuthenticated: isAuthError ? false : state.isAuthenticated,
          errorMessage: e.message,
          failure: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          user: null,
          isAuthenticated: false, // Erreur inconnue, on reste prudent
          errorMessage: e.toString(),
          failure: null,
        ),
      );
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, failure: null));

    try {
      final authenticated = await _checkAuthUseCase();
      final token = authenticated ? await _getTokenUseCase() : null;
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: authenticated,
          token: token,
          user: null, // On ne récupère pas encore l'utilisateur
          errorMessage: null,
          failure: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          user: null,
          errorMessage: e.toString(),
          failure: null,
        ),
      );
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _logoutUseCase();
    emit(const AuthState.initial());
  }
}
