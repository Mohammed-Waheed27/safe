import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Interface for the Auth repository
abstract class AuthRepository {
  /// Authenticate a user with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<Either<Failure, User>> register({
    required String fullName,
    required String email,
    required String password,
  });

  /// Log out the current user
  Future<Either<Failure, void>> logout();

  /// Get the current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Check if a user is currently authenticated
  Future<bool> isAuthenticated();
}
