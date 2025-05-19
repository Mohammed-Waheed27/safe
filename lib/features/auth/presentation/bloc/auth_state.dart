part of 'auth_bloc.dart';

/// Base class for auth states
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {}

/// Loading state during auth operations
class AuthLoading extends AuthState {}

/// Authenticated state with user info
class Authenticated extends AuthState {
  final User user;

  Authenticated({required this.user});

  @override
  List<Object> get props => [user];
}

/// Error state
class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
