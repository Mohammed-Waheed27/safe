import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Register user use case
class RegisterUser implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return repository.register(
      fullName: params.fullName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      password: params.password,
      thirdPartyToken: params.thirdPartyToken,
    );
  }
}

/// Parameters for register use case
class RegisterParams extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? thirdPartyToken;

  const RegisterParams({
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
