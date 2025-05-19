import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC for managing authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  /// Constructor
  AuthBloc({required this.loginUser, required this.registerUser})
    : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Handle login requested event
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final params = LoginParams(email: event.email, password: event.password);

    final result = await loginUser(params);

    result.fold(
      (failure) => emit(AuthError(message: 'Invalid email or password')),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handle register requested event
  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final params = RegisterParams(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
    );

    final result = await registerUser(params);

    result.fold(
      (failure) => emit(AuthError(message: 'Registration failed')),
      (user) => emit(Authenticated(user: user)),
    );
  }

  /// Handle logout requested event
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    // TODO: Implement logout logic
    emit(AuthInitial());
  }
}
