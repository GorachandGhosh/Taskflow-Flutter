import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_auth_state.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/reset_password.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetAuthState getAuthState;
  final ResetPassword? resetPassword;

  StreamSubscription? _authStateSubscription;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.getAuthState,
    this.resetPassword,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);

    // Listen to Firebase Auth state changes
    _authStateSubscription = getAuthState().listen((user) {
      if (user != null) {
        add(AuthCheckRequested());
      }
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentUser = getAuthState.getCurrentUser();
    if (currentUser != null) {
      emit(AuthAuthenticated(currentUser));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await loginUser(event.email, event.password);
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthFailureState(e.message));
    } catch (e) {
      emit(const AuthFailureState('Login failed. Please try again.'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await registerUser(event.email, event.password);
      emit(AuthAuthenticated(user));
    } on AuthFailure catch (e) {
      emit(AuthFailureState(e.message));
    } catch (e) {
      emit(const AuthFailureState('Registration failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await logoutUser();
      emit(AuthUnauthenticated());
    } on AuthFailure catch (e) {
      emit(AuthFailureState(e.message));
    } catch (e) {
      emit(const AuthFailureState('Sign out failed. Please try again.'));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (resetPassword == null) return;
    emit(AuthLoading());
    try {
      await resetPassword!(event.email);
      emit(PasswordResetSent(event.email));
    } on AuthFailure catch (e) {
      emit(AuthFailureState(e.message));
    } catch (e) {
      emit(const AuthFailureState('Failed to send password reset email.'));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
