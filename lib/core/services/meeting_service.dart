import 'package:videosdk/videosdk.dart';
import 'package:flutter/material.dart';

class MeetingService {
  static const int BACK_CAMERA_INDEX = 0;
  static const int FRONT_CAMERA_INDEX = 1;

  static Room createRoom({
    required String roomId,
    required String token,
    required String displayName,
    bool micEnabled = false,
    bool camEnabled = false,
    int cameraIndex = BACK_CAMERA_INDEX,
  }) {
    return VideoSDK.createRoom(
      roomId: roomId,
      token: token,
      displayName: displayName,
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex: cameraIndex,
    );
  }

  static void toggleMic(Room room, bool currentState) {
    try {
      if (currentState) {
        room.muteMic();
      } else {
        room.unmuteMic();
      }
    } catch (e) {
      debugPrint('Error toggling mic: $e');
    }
  }

  static void toggleCamera(Room room, bool currentState) {
    try {
      if (currentState) {
        room.disableCam();
      } else {
        room.enableCam();
      }
    } catch (e) {
      debugPrint('Error toggling camera: $e');
    }
  }

  static Future<void> switchCamera(Room room, bool isCurrentlyFront) async {
    try {
      // Get available cameras
      final cameras = await VideoSDK.getVideoDevices();
      if (cameras == null || cameras.isEmpty) return;

      // Find front or back camera based on current state
      VideoDeviceInfo? targetCamera;
      if (isCurrentlyFront) {
        // Switch to back camera
        targetCamera = cameras.firstWhere(
          (camera) =>
              camera.label.toLowerCase().contains('back') ||
              camera.label.toLowerCase().contains('rear') ||
              camera.label.toLowerCase().contains('environment'),
          orElse: () => cameras.first,
        );
      } else {
        // Switch to front camera
        targetCamera = cameras.firstWhere(
          (camera) =>
              camera.label.toLowerCase().contains('front') ||
              camera.label.toLowerCase().contains('user') ||
              camera.label.toLowerCase().contains('face'),
          orElse: () => cameras.length > 1 ? cameras[1] : cameras.first,
        );
      }

      room.changeCam(targetCamera);
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  // Note: VideoSDK doesn't support flash control directly
  // This would need to be implemented using a separate camera plugin
  static Future<List<VideoDeviceInfo>> getAvailableCameras() async {
    try {
      final cameras = await VideoSDK.getVideoDevices();
      return cameras ?? [];
    } catch (e) {
      debugPrint('Error getting cameras: $e');
      return [];
    }
  }

  static void setupRoomEventListeners(
    Room room, {
    required VoidCallback onRoomJoined,
    required Function(dynamic participant) onParticipantJoined,
    required Function(String participantId) onParticipantLeft,
    required VoidCallback onRoomLeft,
    required Function(dynamic error) onError,
  }) {
    room.on(Events.roomJoined, () {
      debugPrint('Room joined successfully');
      onRoomJoined();
    });

    room.on(Events.participantJoined, (participant) {
      debugPrint('Participant joined: ${participant.id}');
      onParticipantJoined(participant);
    });

    room.on(Events.participantLeft, (participantId) {
      debugPrint('Participant left: $participantId');
      onParticipantLeft(participantId);
    });

    room.on(Events.roomLeft, () {
      debugPrint('Left the room');
      onRoomLeft();
    });

    room.on(Events.error, (error) {
      debugPrint('Room error: $error');
      onError(error);
    });
  }
}
