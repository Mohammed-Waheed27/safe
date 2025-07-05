import 'package:cloud_firestore/cloud_firestore.dart';

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
  });

  factory VideoSDKConfig.fromMap(Map<String, dynamic> map) {
    return VideoSDKConfig(
      apiKey: map['apiKey'] ?? '',
      chatEnabled: map['chatEnabled'] ?? false,
      enabled: map['enabled'] ?? true,
      meetingId: map['meetingId'] ?? '',
      participantId: map['participantId'] ?? '',
      recordingEnabled: map['recordingEnabled'] ?? false,
      roomId: map['roomId'] ?? '',
      screenShareEnabled: map['screenShareEnabled'] ?? false,
      streamUrl: map['streamUrl'] ?? '',
      token: map['token'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'apiKey': apiKey,
      'chatEnabled': chatEnabled,
      'enabled': enabled,
      'meetingId': meetingId,
      'participantId': participantId,
      'recordingEnabled': recordingEnabled,
      'roomId': roomId,
      'screenShareEnabled': screenShareEnabled,
      'streamUrl': streamUrl,
      'token': token,
    };
  }

  VideoSDKConfig copyWith({
    String? apiKey,
    bool? chatEnabled,
    bool? enabled,
    String? meetingId,
    String? participantId,
    bool? recordingEnabled,
    String? roomId,
    bool? screenShareEnabled,
    String? streamUrl,
    String? token,
  }) {
    return VideoSDKConfig(
      apiKey: apiKey ?? this.apiKey,
      chatEnabled: chatEnabled ?? this.chatEnabled,
      enabled: enabled ?? this.enabled,
      meetingId: meetingId ?? this.meetingId,
      participantId: participantId ?? this.participantId,
      recordingEnabled: recordingEnabled ?? this.recordingEnabled,
      roomId: roomId ?? this.roomId,
      screenShareEnabled: screenShareEnabled ?? this.screenShareEnabled,
      streamUrl: streamUrl ?? this.streamUrl,
      token: token ?? this.token,
    );
  }
}

class ZoneModel {
  final String zoneId;
  final String name;
  final String description;
  final int cameras;
  final String createdAt;
  final String createdBy;
  final String currentCount;
  final String image;
  final int maximumCount;
  final String motionStatus;
  final int threshold;
  final String updatedAt;
  final VideoSDKConfig videoSDK;

  const ZoneModel({
    required this.zoneId,
    required this.name,
    required this.description,
    required this.cameras,
    required this.createdAt,
    required this.createdBy,
    required this.currentCount,
    required this.image,
    required this.maximumCount,
    required this.motionStatus,
    required this.threshold,
    required this.updatedAt,
    required this.videoSDK,
  });

  factory ZoneModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ZoneModel(
      zoneId: data['zone_id'] ?? doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      cameras: data['cameras'] ?? 1,
      createdAt: data['created_at'] ?? DateTime.now().toIso8601String(),
      createdBy: data['created_by'] ?? '',
      currentCount: data['current_count'] ?? '0',
      image: data['image'] ?? 'https://via.placeholder.com/400x300?text=Zone+Image',
      maximumCount: data['maximum_count'] ?? 100,
      motionStatus: data['motion_status'] ?? 'active',
      threshold: data['threshold'] ?? 80,
      updatedAt: data['updated_at'] ?? DateTime.now().toIso8601String(),
      videoSDK: VideoSDKConfig.fromMap(data['videoSDK'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zone_id': zoneId,
      'name': name,
      'description': description,
      'cameras': cameras,
      'created_at': createdAt,
      'created_by': createdBy,
      'current_count': currentCount,
      'image': image,
      'maximum_count': maximumCount,
      'motion_status': motionStatus,
      'threshold': threshold,
      'updated_at': updatedAt,
      'videoSDK': videoSDK.toMap(),
    };
  }

  // Helper getters for backward compatibility
  bool get isActive => videoSDK.enabled && videoSDK.roomId.isNotEmpty;
  String? get roomId => videoSDK.roomId.isEmpty ? null : videoSDK.roomId;
  String get userId => createdBy;
  String get zoneToken => videoSDK.token;

  ZoneModel copyWith({
    String? zoneId,
    String? name,
    String? description,
    int? cameras,
    String? createdAt,
    String? createdBy,
    String? currentCount,
    String? image,
    int? maximumCount,
    String? motionStatus,
    int? threshold,
    String? updatedAt,
    VideoSDKConfig? videoSDK,
  }) {
    return ZoneModel(
      zoneId: zoneId ?? this.zoneId,
      name: name ?? this.name,
      description: description ?? this.description,
      cameras: cameras ?? this.cameras,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      currentCount: currentCount ?? this.currentCount,
      image: image ?? this.image,
      maximumCount: maximumCount ?? this.maximumCount,
      motionStatus: motionStatus ?? this.motionStatus,
      threshold: threshold ?? this.threshold,
      updatedAt: updatedAt ?? this.updatedAt,
      videoSDK: videoSDK ?? this.videoSDK,
    );
  }

  // Factory method for creating new zone
  factory ZoneModel.create({
    required String name,
    required String description,
    required String createdBy,
    required String userToken,
    required String apiKey,
    int? maximumCount,
    int? threshold,
  }) {
    final now = DateTime.now().toIso8601String();
    final zoneId = 'zone_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
    
    return ZoneModel(
      zoneId: zoneId,
      name: name,
      description: description,
      cameras: 1,
      createdAt: now,
      createdBy: createdBy,
      currentCount: '0',
      image: 'https://via.placeholder.com/400x300?text=Zone+Image',
      maximumCount: maximumCount ?? 100,
      motionStatus: 'active',
      threshold: threshold ?? 80,
      updatedAt: now,
      videoSDK: VideoSDKConfig(
        apiKey: apiKey,
        chatEnabled: false,
        enabled: true,
        meetingId: '',
        participantId: '',
        recordingEnabled: false,
        roomId: '',
        screenShareEnabled: false,
        streamUrl: '',
        token: userToken,
      ),
    );
  }

  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[DateTime.now().millisecond % chars.length]).join();
  }
}
