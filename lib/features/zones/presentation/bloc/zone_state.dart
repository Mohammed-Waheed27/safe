part of 'zone_bloc.dart';

abstract class ZoneState extends Equatable {
  const ZoneState();

  @override
  List<Object?> get props => [];
}

class ZoneInitial extends ZoneState {}

class ZoneLoading extends ZoneState {}

class ZoneLoaded extends ZoneState {
  final List<ZoneModel> zones;

  const ZoneLoaded({required this.zones});

  @override
  List<Object?> get props => [zones];
}

class ZoneCreated extends ZoneState {
  final List<ZoneModel> zones;

  const ZoneCreated({required this.zones});

  @override
  List<Object?> get props => [zones];
}

class ZoneUpdated extends ZoneState {
  final List<ZoneModel> zones;

  const ZoneUpdated({required this.zones});

  @override
  List<Object?> get props => [zones];
}

class ZoneDeleted extends ZoneState {
  final List<ZoneModel> zones;

  const ZoneDeleted({required this.zones});

  @override
  List<Object?> get props => [zones];
}

class VideoSessionStarted extends ZoneState {
  final String roomId;
  final List<ZoneModel> zones;

  const VideoSessionStarted({required this.roomId, required this.zones});

  @override
  List<Object?> get props => [roomId, zones];
}

class VideoSessionEnded extends ZoneState {
  final List<ZoneModel> zones;

  const VideoSessionEnded({required this.zones});

  @override
  List<Object?> get props => [zones];
}

class ZoneError extends ZoneState {
  final String message;

  const ZoneError({required this.message});

  @override
  List<Object?> get props => [message];
} 