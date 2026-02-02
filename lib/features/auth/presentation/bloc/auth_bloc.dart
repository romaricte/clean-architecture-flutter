import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testapp/core/errors/failures.dart';
import 'package:testapp/features/auth/domain/entities/user.dart';
import 'package:testapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/get_me_usecase.dart';
import 'package:testapp/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required GetMeUseCase getMeUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _getMeUseCase = getMeUseCase,
       _logoutUseCase = logoutUseCase,
       super(const AuthState.initial()) {
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthFetchMeRequested>(_onAuthFetchMeRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  final LoginUseCase _loginUseCase;
  final GetMeUseCase _getMeUseCase;
  final LogoutUseCase _logoutUseCase;

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
    emit(state.copyWith(isLoading: true, errorMessage: null, failure: null));

    try {
      final user = await _getMeUseCase();
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

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await _logoutUseCase();
    emit(const AuthState.initial());
  }
}
