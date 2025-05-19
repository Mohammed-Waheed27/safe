import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Abstract class for defining use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Special type for use cases that don't need any parameters
class NoParams {}
