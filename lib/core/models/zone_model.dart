class VideoSDKConfig {
  final String apiKey;
  final bool chatEnabled;
  final bool enabled;
  final String meetingId;
  final String participantId;
  final bool recordingEnabled;
  final String roomId;
  final bool screenShareEnabled;
  final String streamUrl;
  final String token;
  final String zoneId;

  const VideoSDKConfig({
    required this.apiKey,
    required this.chatEnabled,
    required this.enabled,
    required this.meetingId,
    required this.participantId,
    required this.recordingEnabled,
    required this.roomId,
    required this.screenShareEnabled,
    required this.streamUrl,
    required this.token,
    required this.zoneId,
  });

  factory VideoSDKConfig.fromMap(Map<String, dynamic> data) {
    return VideoSDKConfig(
      apiKey: data['apiKey'] ?? '',
      chatEnabled: data['chatEnabled'] ?? false,
      enabled: data['enabled'] ?? false,
      meetingId: data['meetingId'] ?? '',
      participantId: data['participantId'] ?? '',
      recordingEnabled: data['recordingEnabled'] ?? false,
      roomId: data['roomId'] ?? '',
      screenShareEnabled: data['screenShareEnabled'] ?? false,
      streamUrl: data['streamUrl'] ?? '',
      token: data['token'] ?? '',
      zoneId: data['zone_id'] ?? '',
    );
  }
}

class ZoneModel {
  final String id;
  final int cameras;
  final String createdAt;
  final String createdBy;
  final String currentCount;
  final String description;
  final String image;
  final int maximumCount;
  final String motionStatus;
  final String name;
  final int threshold;
  final String updatedAt;
  final VideoSDKConfig videoSDK;

  const ZoneModel({
    required this.id,
    required this.cameras,
    required this.createdAt,
    required this.createdBy,
    required this.currentCount,
    required this.description,
    required this.image,
    required this.maximumCount,
    required this.motionStatus,
    required this.name,
    required this.threshold,
    required this.updatedAt,
    required this.videoSDK,
  });

  factory ZoneModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ZoneModel(
      id: id,
      cameras: data['cameras'] ?? 0,
      createdAt: data['created_at'] ?? '',
      createdBy: data['created_by'] ?? '',
      currentCount: data['current_count'] ?? '0',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      maximumCount: data['maximum_count'] ?? 0,
      motionStatus: data['motion_status'] ?? '',
      name: data['name'] ?? '',
      threshold: data['threshold'] ?? 0,
      updatedAt: data['updated_at'] ?? '',
      videoSDK: VideoSDKConfig.fromMap(data['videoSDK'] ?? {}),
    );
  }
}
