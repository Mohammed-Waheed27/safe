import 'package:dio/dio.dart';

import '../models/user_model.dart';

/// Interface for authentication remote data source
abstract class AuthRemoteDataSource {
  /// Login user with email and password
  Future<UserModel> login(String email, String password);

  /// Register new user
  Future<UserModel> register(String fullName, String email, String password);

  /// Logout user
  Future<void> logout();

  /// Get current user
  Future<UserModel?> getCurrentUser();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement with Firebase or other backend
    // This is a placeholder implementation that returns dummy data
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: '1',
      fullName: 'Demo User',
      email: email,
      photoUrl: null,
    );
  }

  @override
  Future<UserModel> register(
    String fullName,
    String email,
    String password,
  ) async {
    // TODO: Implement with Firebase or other backend
    // This is a placeholder implementation that returns dummy data
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(id: '1', fullName: fullName, email: email, photoUrl: null);
  }

  @override
  Future<void> logout() async {
    // TODO: Implement with Firebase or other backend
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // TODO: Implement with Firebase or other backend
    return null;
  }
}
