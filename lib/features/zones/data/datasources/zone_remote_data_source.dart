import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:http/http.dart' as http;

import '../models/zone_model.dart';
import '../../../../core/config/app_router.dart';

abstract class ZoneRemoteDataSource {
  Future<ZoneModel?> getUserZone();
  Future<String> getUserTokenFromFirestore(String userId);
  Future<void> createZone(ZoneModel zone);
  Future<void> updateZone(ZoneModel zone);
  Future<void> deleteZone(String userId);
  Future<String> createVideoSession(String userId);
  Future<void> endVideoSession(String userId);
}

class ZoneRemoteDataSourceImpl implements ZoneRemoteDataSource {
  final FirebaseFirestore firestore;

  // Fallback token for demo
  String get fallbackToken =>
      dotenv.env['main_token'] ??
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI5YjQ4ODEwOC0wNjk0LTQ1ZGMtOGM2ZC1hNzQ1NmY1NGEzN2QiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcwODk2MzU0MSwiZXhwIjoxNzE2NzM5NTQxfQ.BruXhAuGULv-BW-8KQIjPNa8u3DjZhDL8YCUW6YSyGU';

  String get apiUrl =>
      dotenv.env['Api_Url'] ?? 'https://api.videosdk.live/v2/rooms';

  ZoneRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ZoneModel?> getUserZone() async {
    try {
      // Get current user ID
      final currentUserId = await AppRouter.currentUserId;
      if (currentUserId == null || currentUserId.isEmpty) {
        throw Exception('User not logged in');
      }

      print('Fetching zone for user: $currentUserId');
      // Use user ID as document ID - no complex query needed, no index required
      final doc = await firestore.collection('zones').doc(currentUserId).get();

      if (!doc.exists) {
        print('No zone document found for user: $currentUserId');
        return null; // User has no zone yet
      }

      print('Zone document found, creating ZoneModel...');
      final zone = ZoneModel.fromFirestore(doc);
      print('Zone loaded: ${zone.name}');
      return zone;
    } catch (e) {
      print('Error getting user zone: $e');
      throw Exception('Failed to get user zone: $e');
    }
  }

  @override
  Future<String> getUserTokenFromFirestore(String userId) async {
    try {
      // Fetch user token from users collection
      final userDoc = await firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        print('User document not found, using fallback token');
        return fallbackToken;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final userToken =
          userData['thirdPartyToken'] ??
          userData['token'] ??
          userData['videoSDKToken'];

      if (userToken == null || userToken.isEmpty) {
        print('User token not found in document, using fallback token');
        return fallbackToken;
      }

      return userToken as String;
    } catch (e) {
      print('Error fetching user token: $e, using fallback token');
      return fallbackToken;
    }
  }

  @override
  Future<void> createZone(ZoneModel zone) async {
    try {
      print(
        'Creating zone in Firebase: ${zone.name} for user: ${zone.createdBy}',
      );
      // Use user ID as document ID for easy access
      await firestore.collection('zones').doc(zone.createdBy).set(zone.toMap());
      print('Zone created successfully in Firebase');
    } catch (e) {
      print('Error creating zone in Firebase: $e');
      throw Exception('Failed to create zone: $e');
    }
  }

  @override
  Future<void> updateZone(ZoneModel zone) async {
    try {
      print(
        'Updating zone in Firebase: ${zone.name} for user: ${zone.createdBy}',
      );
      // Update using user ID as document ID
      await firestore
          .collection('zones')
          .doc(zone.createdBy)
          .update(zone.toMap());
      print('Zone updated successfully in Firebase');
    } catch (e) {
      print('Error updating zone in Firebase: $e');
      throw Exception('Failed to update zone: $e');
    }
  }

  @override
  Future<void> deleteZone(String userId) async {
    try {
      // Delete using user ID as document ID
      await firestore.collection('zones').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete zone: $e');
    }
  }

  @override
  Future<String> createVideoSession(String userId) async {
    try {
      // Get the user's zone
      final zone = await getUserZone();
      if (zone == null) {
        throw Exception('User zone not found');
      }

      // Use zone's token to create meeting
      final sessionToken =
          zone.videoSDK.token.isNotEmpty ? zone.videoSDK.token : fallbackToken;

      // Create meeting using VideoSDK API
      final http.Response httpResponse = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': sessionToken},
      );

      if (httpResponse.statusCode != 200) {
        throw Exception(
          'Failed to create video session: ${httpResponse.statusCode}',
        );
      }

      final responseData = jsonDecode(httpResponse.body);
      final roomId = responseData['roomId'] as String;
      final meetingId = 'meeting-${DateTime.now().millisecondsSinceEpoch}';

      // Update zone with new session info
      final updatedVideoSDK = zone.videoSDK.copyWith(
        enabled: true,
        roomId: roomId,
        meetingId: meetingId,
      );

      final updatedZone = zone.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
        videoSDK: updatedVideoSDK,
      );

      await updateZone(updatedZone);

      // Store active feed
      await createZoneFeedId(roomId, zone.zoneId);

      return roomId;
    } catch (e) {
      throw Exception('Failed to create video session: $e');
    }
  }

  @override
  Future<void> endVideoSession(String userId) async {
    try {
      final zone = await getUserZone();
      if (zone == null) {
        throw Exception('User zone not found');
      }

      final roomId = zone.videoSDK.roomId;
      if (roomId.isNotEmpty) {
        // Delete the active feed
        await deleteZoneFeed(roomId);
      }

      // Update zone to disable session
      final updatedVideoSDK = zone.videoSDK.copyWith(
        enabled: false,
        roomId: '',
        meetingId: '',
      );

      final updatedZone = zone.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
        videoSDK: updatedVideoSDK,
      );

      await updateZone(updatedZone);
    } catch (e) {
      throw Exception('Failed to end video session: $e');
    }
  }

  // Helper methods for active feeds
  Future<void> createZoneFeedId(String roomId, String zoneId) async {
    await firestore
        .collection("active_zone_feeds")
        .doc('zone_feed_$roomId')
        .set({
          "roomId": roomId,
          "zoneId": zoneId,
          "createdAt": FieldValue.serverTimestamp(),
        });
  }

  Future<void> deleteZoneFeed(String roomId) async {
    try {
      await firestore
          .collection("active_zone_feeds")
          .doc('zone_feed_$roomId')
          .delete();
    } catch (e) {
      print('Error deleting zone feed: $e');
    }
  }
}
