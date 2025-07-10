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
    try {
      debugPrint('Creating VideoSDK room with:');
      debugPrint('- Room ID: $roomId');
      debugPrint('- Display Name: $displayName');
      debugPrint('- Mic Enabled: $micEnabled');
      debugPrint('- Camera Enabled: $camEnabled');
      debugPrint('- Camera Index: $cameraIndex');

      final room = VideoSDK.createRoom(
        roomId: roomId,
        token: token,
        displayName: displayName,
        micEnabled: micEnabled,
        camEnabled: camEnabled,
        defaultCameraIndex: cameraIndex,
      );

      debugPrint('Room created successfully');
      return room;
    } catch (e) {
      debugPrint('Error creating room: $e');
      rethrow;
    }
  }

  static void toggleMic(Room room, bool currentState) {
    try {
      debugPrint(
        'Toggling mic: currently ${currentState ? 'enabled' : 'disabled'}',
      );
      if (currentState) {
        room.muteMic();
        debugPrint('Mic muted');
      } else {
        room.unmuteMic();
        debugPrint('Mic unmuted');
      }
    } catch (e) {
      debugPrint('Error toggling mic: $e');
    }
  }

  static void toggleCamera(Room room, bool currentState) {
    try {
      debugPrint(
        'Toggling camera: currently ${currentState ? 'enabled' : 'disabled'}',
      );
      if (currentState) {
        room.disableCam();
        debugPrint('Camera disabled');
      } else {
        room.enableCam();
        debugPrint('Camera enabled');
      }
    } catch (e) {
      debugPrint('Error toggling camera: $e');
    }
  }

  static Future<void> switchCamera(Room room, bool isCurrentlyFront) async {
    try {
      debugPrint(
        'Switching camera from ${isCurrentlyFront ? 'front' : 'back'} to ${isCurrentlyFront ? 'back' : 'front'}',
      );

      // Get available cameras with error handling
      final cameras = await getAvailableCameras();
      if (cameras.isEmpty) {
        debugPrint('No cameras available');
        return;
      }

      debugPrint('Available cameras: ${cameras.length}');
      for (int i = 0; i < cameras.length; i++) {
        debugPrint('Camera $i: ${cameras[i].label}');
      }

      // Find target camera based on current state
      VideoDeviceInfo? targetCamera;

      if (isCurrentlyFront) {
        // Switch to back camera - look for keywords or use index 0 as fallback
        targetCamera = cameras.firstWhere(
          (camera) {
            final label = camera.label.toLowerCase();
            return label.contains('back') ||
                label.contains('rear') ||
                label.contains('environment') ||
                label.contains('main');
          },
          orElse:
              () => cameras.first, // Fallback to first camera (usually back)
        );
      } else {
        // Switch to front camera - look for keywords or use index 1 as fallback
        targetCamera = cameras.firstWhere((camera) {
          final label = camera.label.toLowerCase();
          return label.contains('front') ||
              label.contains('user') ||
              label.contains('face') ||
              label.contains('selfie');
        }, orElse: () => cameras.length > 1 ? cameras[1] : cameras.first);
      }

      if (targetCamera != null) {
        debugPrint('Switching to camera: ${targetCamera.label}');
        await room.changeCam(targetCamera);
        debugPrint('Camera switched successfully');
      } else {
        debugPrint('No suitable camera found for switching');
      }
    } catch (e) {
      debugPrint('Error switching camera: $e');
      // Don't rethrow - camera switching failures shouldn't crash the app
    }
  }

  static Future<List<VideoDeviceInfo>> getAvailableCameras() async {
    try {
      debugPrint('Getting available cameras...');
      final cameras = await VideoSDK.getVideoDevices();
      final cameraList = cameras ?? [];
      debugPrint('Found ${cameraList.length} cameras');
      return cameraList;
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
    try {
      debugPrint('Setting up room event listeners...');

      room.on(Events.roomJoined, () {
        debugPrint('Event: Room joined successfully');
        onRoomJoined();
      });

      room.on(Events.participantJoined, (participant) {
        debugPrint(
          'Event: Participant joined: ${participant?.id ?? 'unknown'}',
        );
        onParticipantJoined(participant);
      });

      room.on(Events.participantLeft, (participantId) {
        debugPrint('Event: Participant left: $participantId');
        onParticipantLeft(participantId);
      });

      room.on(Events.roomLeft, () {
        debugPrint('Event: Left the room');
        onRoomLeft();
      });

      room.on(Events.error, (error) {
        debugPrint('Event: Room error: $error');
        onError(error);
      });

      // Add additional event listeners for better error handling
      room.on(Events.micRequested, () {
        debugPrint('Event: Microphone requested');
      });

      debugPrint('Room event listeners set up successfully');
    } catch (e) {
      debugPrint('Error setting up room event listeners: $e');
      throw e;
    }
  }
}
