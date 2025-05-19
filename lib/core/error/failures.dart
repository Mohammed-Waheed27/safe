import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

/// Server failure
class ServerFailure extends Failure {
  final String? message;

  ServerFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

/// Cache failure
class CacheFailure extends Failure {}

/// Network failure
class NetworkFailure extends Failure {}

/// Authentication failure
class AuthFailure extends Failure {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, String> errors;

  ValidationFailure({required this.errors});

  @override
  List<Object> get props => [errors];
}
