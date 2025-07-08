import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../../core/models/meeting_state.dart';
import '../../../core/services/meeting_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/flash_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/appthme.dart';
import '../widgets/enhanced_meeting_controls.dart';
import '../widgets/enhanced_participant_tile.dart';
import '../../../api_call.dart';
import 'search rooms/search_active_feeds.dart';
import '../../auth/pages/login_page.dart';

class EnhancedMeetingScreen extends StatefulWidget {
  final String meetingId;
  final String token;

  const EnhancedMeetingScreen({
    super.key,
    required this.meetingId,
    required this.token,
  });

  @override
  State<EnhancedMeetingScreen> createState() => _EnhancedMeetingScreenState();
}

class _EnhancedMeetingScreenState extends State<EnhancedMeetingScreen> {
  late Room _room;
  MeetingState _meetingState = const MeetingState();
  StreamSubscription<DocumentSnapshot>? _roomSubscription;
  Map<String, Participant> participants = {};

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Request permissions first
    final hasPermissions =
        await PermissionService.requestCameraAndMicPermissions();
    if (!hasPermissions) {
      _setState(
        _meetingState.copyWith(
          isInitializing: false,
          errorMessage: 'Camera and microphone permissions are required',
        ),
      );
      return;
    }

    _initializeRoom();
    _startRoomMonitoring();
  }

  void _setState(MeetingState newState) {
    if (mounted) {
      setState(() {
        _meetingState = newState;
      });
    }
  }

  void _initializeRoom() {
    try {
      _setState(
        _meetingState.copyWith(isInitializing: true, errorMessage: null),
      );

      _room = MeetingService.createRoom(
        roomId: widget.meetingId,
        token: widget.token,
        displayName: "Phone_Live",
        micEnabled: _meetingState.isMicEnabled, // Start with mic disabled
        camEnabled: _meetingState.isCameraEnabled, // Start with camera disabled
        cameraIndex: _meetingState.isFrontCamera ? 1 : 0,
      );

      MeetingService.setupRoomEventListeners(
        _room,
        onRoomJoined: _onRoomJoined,
        onParticipantJoined: _onParticipantJoined,
        onParticipantLeft: _onParticipantLeft,
        onRoomLeft: _onRoomLeft,
        onError: _onRoomError,
      );

      _room.join();
    } catch (e) {
      _setState(
        _meetingState.copyWith(
          isInitializing: false,
          errorMessage: 'Failed to initialize room: ${e.toString()}',
        ),
      );
      _leaveRoomWithMessage('Failed to join the room');
    }
  }

  void _onRoomJoined() {
    debugPrint('Room joined successfully');
    setState(() {
      // Only add local participant - we don't want to show other participants
      participants[_room.localParticipant.id] = _room.localParticipant;
    });

    _setState(_meetingState.copyWith(isInitializing: false));
  }

  void _onParticipantJoined(dynamic participant) {
    // Don't add remote participants to the UI - only show local feed
    if (participant is Participant) {
      debugPrint(
        'Remote participant joined: ${participant.id}, but not showing in UI',
      );
      // We intentionally don't add remote participants to the participants map
      // so they won't be displayed in the UI
    }
  }

  void _onParticipantLeft(String participantId) {
    // Only remove if it's the local participant leaving
    if (participantId == _room.localParticipant.id) {
      setState(() {
        participants.remove(participantId);
      });
    }
    debugPrint('Remote participant left: $participantId');
  }

  void _onRoomLeft() {
    setState(() {
      participants.clear();
    });
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => searchActiveFeeds()),
      );
    }
  }

  void _onRoomError(dynamic error) {
    _setState(
      _meetingState.copyWith(errorMessage: 'Room error: ${error.toString()}'),
    );
    _leaveRoomWithMessage('An error occurred in the room');
  }

  void _startRoomMonitoring() {
    _roomSubscription?.cancel();
    _roomSubscription = FirebaseFirestore.instance
        .collection('active_feeds')
        .doc('current_feed')
        .snapshots()
        .listen(
          (doc) {
            if (!doc.exists || doc.data()?['roomId'] != widget.meetingId) {
              if (mounted) {
                _leaveRoomWithMessage('The live feed has ended');
              }
            }
          },
          onError: (error) {
            if (mounted) {
              _leaveRoomWithMessage('Error monitoring feed status');
            }
          },
        );
  }

  void _leaveRoomWithMessage(String message) {
    try {
      _room.leave();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => searchActiveFeeds()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => searchActiveFeeds()),
        );
      }
    }
  }

  void _toggleMic() {
    MeetingService.toggleMic(_room, _meetingState.isMicEnabled);
    _setState(
      _meetingState.copyWith(isMicEnabled: !_meetingState.isMicEnabled),
    );
  }

  void _toggleCamera() {
    MeetingService.toggleCamera(_room, _meetingState.isCameraEnabled);
    _setState(
      _meetingState.copyWith(isCameraEnabled: !_meetingState.isCameraEnabled),
    );
  }

  Future<void> _switchCamera() async {
    await MeetingService.switchCamera(_room, _meetingState.isFrontCamera);

    // Turn off flash when switching to front camera (most devices don't have front flash)
    bool newFlashState = _meetingState.isFlashEnabled;
    if (_meetingState.isFrontCamera) {
      // Switching to back camera, keep current flash state
    } else {
      // Switching to front camera, turn off flash
      newFlashState = false;
      if (_meetingState.isFlashEnabled) {
        await FlashService.setFlash(false);
      }
    }

    _setState(
      _meetingState.copyWith(
        isFrontCamera: !_meetingState.isFrontCamera,
        isFlashEnabled: newFlashState,
      ),
    );
  }

  Future<void> _toggleFlash() async {
    final newFlashState = await FlashService.toggleFlash();
    _setState(_meetingState.copyWith(isFlashEnabled: newFlashState));
  }

  Future<bool> _onWillPop() async {
    _leaveRoomWithMessage('You left the live feed');
    return true;
  }

  Future<void> _logout() async {
    try {
      _room.leave();
      await AuthService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: Text(
            'Phone Live',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
            onPressed: () => _onWillPop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline, color: AppTheme.textPrimaryColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Room ID: ${widget.meetingId}'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: AppTheme.textPrimaryColor),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(padding: EdgeInsets.all(16.w), child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_meetingState.errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_meetingState.isInitializing) {
      return _buildLoadingWidget();
    }

    return Column(
      children: [
        // Meeting info
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 1.w,
            ),
          ),
          child: Text(
            'Your Live Feed • Broadcasting',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16.h),

        // Video area - Only show local participant
        Expanded(child: _buildLocalParticipantView()),

        SizedBox(height: 16.h),

        // Controls
        EnhancedMeetingControls(
          onToggleMicButtonPressed: _toggleMic,
          onToggleCameraButtonPressed: _toggleCamera,
          onSwitchCameraButtonPressed: _switchCamera,
          onToggleFlashButtonPressed: _toggleFlash,
          onLeaveButtonPressed:
              () => _leaveRoomWithMessage('You left the live feed'),
          isMicEnabled: _meetingState.isMicEnabled,
          isCameraEnabled: _meetingState.isCameraEnabled,
          isFrontCamera: _meetingState.isFrontCamera,
          isFlashEnabled: _meetingState.isFlashEnabled,
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              _meetingState.errorMessage!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => _initializeApp(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryColor,
            strokeWidth: 3.w,
          ),
          SizedBox(height: 24.h),
          Text(
            'Connecting to live feed...',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please wait while we connect you',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalParticipantView() {
    // Always show only the local participant (your phone's camera)
    if (participants.isNotEmpty &&
        participants.containsKey(_room.localParticipant.id)) {
      final localParticipant = participants[_room.localParticipant.id]!;
      return EnhancedParticipantTile(
        key: Key(localParticipant.id),
        participant: localParticipant,
        isLocalParticipant: true,
      );
    }

    // Show message when camera is off or not connected
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _meetingState.isCameraEnabled ? Icons.videocam : Icons.videocam_off,
            size: 80.sp,
            color:
                _meetingState.isCameraEnabled
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16.h),
          Text(
            _meetingState.isCameraEnabled
                ? 'Connecting your camera...'
                : 'Camera is disabled',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _meetingState.isCameraEnabled
                ? 'Please wait while we start your video feed'
                : 'Tap the camera button to enable your video',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    try {
      _room.leave();
    } catch (e) {
      debugPrint('Error leaving room on dispose: $e');
    }
    super.dispose();
  }
}
