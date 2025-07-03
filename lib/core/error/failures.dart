import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  /// Message describing the failure
  String get message;

  @override
  List<Object> get props => [];
}

/// Server failure
class ServerFailure extends Failure {
  final String? _message;

  ServerFailure({String? message}) : _message = message;

  @override
  String get message => _message ?? 'Server error occurred';

  @override
  List<Object> get props => [message];
}

/// Cache failure
class CacheFailure extends Failure {
  @override
  String get message => 'Cache error occurred';
}

/// Network failure
class NetworkFailure extends Failure {
  @override
  String get message => 'Network error occurred';
}

/// Authentication failure
class AuthFailure extends Failure {
  final String _message;

  AuthFailure({required String message}) : _message = message;

  @override
  String get message => _message;

  @override
  List<Object> get props => [message];
}

/// Validation failure
class ValidationFailure extends Failure {
  final Map<String, String> errors;

  ValidationFailure({required this.errors});

  @override
  String get message => 'Validation failed: ${errors.values.join(', ')}';

  @override
  List<Object> get props => [errors];
}
