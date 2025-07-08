import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static Future<bool> requestCameraAndMicPermissions() async {
    try {
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.camera, Permission.microphone].request();

      final cameraGranted =
          statuses[Permission.camera] == PermissionStatus.granted;
      final micGranted =
          statuses[Permission.microphone] == PermissionStatus.granted;

      debugPrint('Camera permission: $cameraGranted');
      debugPrint('Microphone permission: $micGranted');

      return cameraGranted && micGranted;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  static Future<bool> checkPermissions() async {
    try {
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      return cameraStatus == PermissionStatus.granted &&
          micStatus == PermissionStatus.granted;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return false;
    }
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
