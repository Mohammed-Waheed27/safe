import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../datasources/zone_remote_data_source.dart';
import '../models/zone_model.dart';
import '../../domain/repositories/zone_repository.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  final ZoneRemoteDataSource remoteDataSource;

  ZoneRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> getUserThirdPartyToken() async {
    try {
      // This will be handled in the UI layer now
      return const Right('');
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createZoneSession() async {
    try {
      // Get current user's zone and create session
      final zone = await remoteDataSource.getUserZone();
      if (zone == null) {
        return Left(ServerFailure(message: 'No zone found for user'));
      }

      final sessionId = await remoteDataSource.createVideoSession(
        zone.createdBy,
      );
      return Right(sessionId);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createZone(ZoneModel zone) async {
    try {
      await remoteDataSource.createZone(zone);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateZone(ZoneModel zone) async {
    try {
      await remoteDataSource.updateZone(zone);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteZone(String zoneId) async {
    try {
      // Extract user ID from zone or get current user
      // For now, we'll need to pass user ID differently
      await remoteDataSource.deleteZone(zoneId); // This is now user ID
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ZoneModel?>> getZone(String zoneId) async {
    try {
      // Get user's zone instead of specific zone
      final zone = await remoteDataSource.getUserZone();
      return Right(zone);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ZoneModel>>> getZones() async {
    try {
      // Get user's single zone and return as list for compatibility
      final zone = await remoteDataSource.getUserZone();
      final zones = zone != null ? [zone] : <ZoneModel>[];
      return Right(zones);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // New method for fetching user token from Firestore
  Future<Either<Failure, String>> getUserTokenFromFirestore(
    String userId,
  ) async {
    try {
      final token = await remoteDataSource.getUserTokenFromFirestore(userId);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
