part of 'zone_bloc.dart';

abstract class ZoneEvent extends Equatable {
  const ZoneEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserZone extends ZoneEvent {}

class CreateZone extends ZoneEvent {
  final ZoneModel zone;

  const CreateZone({required this.zone});

  @override
  List<Object?> get props => [zone];
}

class UpdateZone extends ZoneEvent {
  final ZoneModel zone;

  const UpdateZone({required this.zone});

  @override
  List<Object?> get props => [zone];
}

class DeleteUserZone extends ZoneEvent {}

class StartVideoSession extends ZoneEvent {}

class EndVideoSession extends ZoneEvent {}
