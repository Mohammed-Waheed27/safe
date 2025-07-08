class MeetingState {
  final bool isMicEnabled;
  final bool isCameraEnabled;
  final bool isFlashEnabled;
  final bool isFrontCamera;
  final bool isInitializing;
  final String? errorMessage;
  final Map<String, dynamic> participants;

  const MeetingState({
    this.isMicEnabled = false,
    this.isCameraEnabled = false,
    this.isFlashEnabled = false,
    this.isFrontCamera = true, // Start with front camera
    this.isInitializing = true,
    this.errorMessage,
    this.participants = const {},
  });

  MeetingState copyWith({
    bool? isMicEnabled,
    bool? isCameraEnabled,
    bool? isFlashEnabled,
    bool? isFrontCamera,
    bool? isInitializing,
    String? errorMessage,
    Map<String, dynamic>? participants,
  }) {
    return MeetingState(
      isMicEnabled: isMicEnabled ?? this.isMicEnabled,
      isCameraEnabled: isCameraEnabled ?? this.isCameraEnabled,
      isFlashEnabled: isFlashEnabled ?? this.isFlashEnabled,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isInitializing: isInitializing ?? this.isInitializing,
      errorMessage: errorMessage ?? this.errorMessage,
      participants: participants ?? this.participants,
    );
  }
}
