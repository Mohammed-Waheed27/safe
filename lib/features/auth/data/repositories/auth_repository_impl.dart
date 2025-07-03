import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of the Auth repository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  /// Constructor
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🏗️ Repository: Starting user login for email: $email');
      
      final userModel = await remoteDataSource.login(email, password);
      
      print('✅ Repository: User login successful');
      return Right(userModel);
    } catch (e) {
      print('❌ Repository: Login failed - ${e.toString()}');
      return Left(AuthFailure(message: 'Invalid email or password: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    String? thirdPartyToken,
  }) async {
    try {
      print('🏗️ Repository: Starting user registration');
      print('📝 Registration data: name=$fullName, email=$email, phone=$phoneNumber');
      
      final userModel = await remoteDataSource.register(
        fullName,
        email,
        phoneNumber,
        password,
        thirdPartyToken: thirdPartyToken,
      );
      
      print('✅ Repository: User registration successful');
      return Right(userModel);
    } catch (e) {
      print('❌ Repository: Registration failed - ${e.toString()}');
      return Left(AuthFailure(message: 'Failed to register user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to log out'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
