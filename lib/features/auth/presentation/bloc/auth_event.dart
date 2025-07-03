part of 'auth_bloc.dart';

/// Base class for auth events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event for login request
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Event for registration request
class RegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? thirdPartyToken;

  RegisterRequested({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.thirdPartyToken,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    password,
    thirdPartyToken,
  ];
}

/// Event for logout request
class LogoutRequested extends AuthEvent {}
