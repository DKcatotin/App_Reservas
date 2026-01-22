import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../domain/usecases/login_owner_usecase.dart';
import '../../domain/usecases/logout_owner_usecase.dart';
import '../../domain/usecases/get_current_owner_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginOwnerUseCase loginUseCase;
  final LogoutOwnerUseCase logoutUseCase;
  final GetCurrentOwnerUseCase getCurrentOwnerUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentOwnerUseCase,
  }) : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckSession>(_onCheckSession);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (owner) => emit(AuthAuthenticated(owner)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckSession(
    CheckSession event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentOwnerUseCase();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (owner) => emit(AuthAuthenticated(owner)),
    );
  }
}