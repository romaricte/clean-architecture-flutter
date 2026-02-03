import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/core/errors/failures.dart';
import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_me_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthUseCase checkAuthUseCase,
    required GetMeUseCase getMeUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _checkAuthUseCase = checkAuthUseCase,
       _getMeUseCase = getMeUseCase,
       super(const AuthState.initial()) {
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthFetchMeRequested>(_onAuthFetchMeRequested);
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthUseCase _checkAuthUseCase;
  final GetMeUseCase _getMeUseCase;

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
      emit(
        state.copyWith(
          isLoading: false,
          user: user,
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
    print('DEBUG: AuthFetchMeRequested received');
    emit(state.copyWith(isLoading: true, errorMessage: null, failure: null));

    try {
      final authenticated = await _checkAuthUseCase();
      print('DEBUG: authenticated: $authenticated');

      if (authenticated) {
        final user = await _getMeUseCase();
        print('DEBUG: user fetched: ${user.fullName}');
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
            errorMessage: null,
            failure: null,
          ),
        );
      } else {
        print('DEBUG: not authenticated');
        emit(
          state.copyWith(
            isLoading: false,
            user: null,
            errorMessage: null,
            failure: null,
          ),
        );
      }
    } on Failure catch (e) {
      print('DEBUG: AuthFetchMeRequested Failure: ${e.message}');
      emit(
        state.copyWith(
          isLoading: false,
          user: null,
          errorMessage: null,
          failure: e,
        ),
      );
    } catch (e) {
      print('DEBUG: AuthFetchMeRequested Exception: $e');
      emit(
        state.copyWith(
          isLoading: false,
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
