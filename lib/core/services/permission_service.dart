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

  static Future<bool> requestCameraAndMicPermissionsWithHandling() async {
    try {
      // Check current status first
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      debugPrint('Initial Camera permission status: $cameraStatus');
      debugPrint('Initial Microphone permission status: $micStatus');

      // If already granted, return true
      if (cameraStatus == PermissionStatus.granted &&
          micStatus == PermissionStatus.granted) {
        return true;
      }

      // Request permissions
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.camera, Permission.microphone].request();

      final cameraGranted =
          statuses[Permission.camera] == PermissionStatus.granted;
      final micGranted =
          statuses[Permission.microphone] == PermissionStatus.granted;

      debugPrint('Final Camera permission: $cameraGranted');
      debugPrint('Final Microphone permission: $micGranted');

      // Check for permanently denied
      if (statuses[Permission.camera] == PermissionStatus.permanentlyDenied ||
          statuses[Permission.microphone] ==
              PermissionStatus.permanentlyDenied) {
        debugPrint('Permissions permanently denied - need to open settings');
        return false;
      }

      return cameraGranted && micGranted;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  static Future<bool> arePermissionsPermanentlyDenied() async {
    try {
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      return cameraStatus == PermissionStatus.permanentlyDenied ||
          micStatus == PermissionStatus.permanentlyDenied;
    } catch (e) {
      debugPrint('Error checking permanently denied permissions: $e');
      return false;
    }
  }

  static Future<bool> openDeviceSettings() async {
    try {
      // Use the global openAppSettings function from permission_handler
      return await openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
      return false;
    }
  }
}
