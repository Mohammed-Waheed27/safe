import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/zone_model.dart';

abstract class ZoneRepository {
  Future<Either<Failure, String>> getUserThirdPartyToken();
  Future<Either<Failure, String>> createZoneSession();
  Future<Either<Failure, Unit>> createZone(ZoneModel zone);
  Future<Either<Failure, Unit>> updateZone(ZoneModel zone);
  Future<Either<Failure, Unit>> deleteZone(String zoneId);
  Future<Either<Failure, ZoneModel?>> getZone(String zoneId);
  Future<Either<Failure, List<ZoneModel>>> getZones();
}
