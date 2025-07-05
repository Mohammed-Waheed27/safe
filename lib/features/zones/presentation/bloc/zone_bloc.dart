import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/zone_model.dart';
import '../../domain/repositories/zone_repository.dart';
import '../../data/datasources/zone_remote_data_source.dart';
import '../../../../core/config/app_router.dart';

part 'zone_event.dart';
part 'zone_state.dart';

class ZoneBloc extends Bloc<ZoneEvent, ZoneState> {
  final ZoneRemoteDataSource remoteDataSource;

  ZoneBloc({required this.remoteDataSource}) : super(ZoneInitial()) {
    on<LoadUserZone>(_onLoadUserZone);
    on<CreateZone>(_onCreateZone);
    on<UpdateZone>(_onUpdateZone);
    on<DeleteUserZone>(_onDeleteUserZone);
    on<StartVideoSession>(_onStartVideoSession);
    on<EndVideoSession>(_onEndVideoSession);
  }

  Future<void> _onLoadUserZone(
    LoadUserZone event,
    Emitter<ZoneState> emit,
  ) async {
    try {
      print('Loading user zone...');
      emit(ZoneLoading());
      final zone = await remoteDataSource.getUserZone();
      if (zone != null) {
        print('Zone loaded: ${zone.name}');
        emit(ZoneLoaded(zones: [zone]));
      } else {
        print('No zone found for user');
        emit(ZoneLoaded(zones: [])); // No zone for user
      }
    } catch (e) {
      print('Error loading zone: $e');
      emit(ZoneError(message: e.toString()));
    }
  }

  Future<void> _onCreateZone(CreateZone event, Emitter<ZoneState> emit) async {
    try {
      print('Creating zone: ${event.zone.name}');
      emit(ZoneLoading());
      await remoteDataSource.createZone(event.zone);
      print('Zone created successfully');

      // Verify the zone was saved by reloading it
      print('Verifying zone was saved...');
      final zone = await remoteDataSource.getUserZone();
      if (zone == null) {
        throw Exception(
          'Zone was not saved properly - could not retrieve after creation',
        );
      }
      final zones = [zone];
      print('Zone verification successful: ${zone.name}');
      emit(ZoneCreated(zones: zones));
    } catch (e) {
      print('Error creating zone: $e');
      emit(ZoneError(message: e.toString()));
    }
  }

  Future<void> _onUpdateZone(UpdateZone event, Emitter<ZoneState> emit) async {
    try {
      print('Updating zone: ${event.zone.name}');
      emit(ZoneLoading());
      await remoteDataSource.updateZone(event.zone);
      print('Zone updated successfully');

      // Verify the zone was updated by reloading it
      print('Verifying zone was updated...');
      final zone = await remoteDataSource.getUserZone();
      if (zone == null) {
        throw Exception(
          'Zone was not updated properly - could not retrieve after update',
        );
      }
      final zones = [zone];
      print('Zone update verification successful: ${zone.name}');
      emit(ZoneUpdated(zones: zones));
    } catch (e) {
      print('Error updating zone: $e');
      emit(ZoneError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUserZone(
    DeleteUserZone event,
    Emitter<ZoneState> emit,
  ) async {
    try {
      emit(ZoneLoading());
      final currentUserId = await AppRouter.currentUserId;
      if (currentUserId == null) {
        throw Exception('User not logged in');
      }

      await remoteDataSource.deleteZone(currentUserId);
      emit(ZoneDeleted(zones: [])); // No zones after deletion
    } catch (e) {
      emit(ZoneError(message: e.toString()));
    }
  }

  Future<void> _onStartVideoSession(
    StartVideoSession event,
    Emitter<ZoneState> emit,
  ) async {
    try {
      emit(ZoneLoading());
      final currentUserId = await AppRouter.currentUserId;
      if (currentUserId == null) {
        throw Exception('User not logged in');
      }

      final roomId = await remoteDataSource.createVideoSession(currentUserId);

      // Reload user zone after starting session
      final zone = await remoteDataSource.getUserZone();
      final zones = zone != null ? [zone] : <ZoneModel>[];
      emit(VideoSessionStarted(roomId: roomId, zones: zones));
    } catch (e) {
      emit(ZoneError(message: e.toString()));
    }
  }

  Future<void> _onEndVideoSession(
    EndVideoSession event,
    Emitter<ZoneState> emit,
  ) async {
    try {
      emit(ZoneLoading());
      final currentUserId = await AppRouter.currentUserId;
      if (currentUserId == null) {
        throw Exception('User not logged in');
      }

      await remoteDataSource.endVideoSession(currentUserId);

      // Reload user zone after ending session
      final zone = await remoteDataSource.getUserZone();
      final zones = zone != null ? [zone] : <ZoneModel>[];
      emit(VideoSessionEnded(zones: zones));
    } catch (e) {
      emit(ZoneError(message: e.toString()));
    }
  }
}
