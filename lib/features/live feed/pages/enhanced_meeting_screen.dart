import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../../../core/models/meeting_state.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/flash_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/appthme.dart';
import '../widgets/enhanced_meeting_controls.dart';
import '../widgets/enhanced_participant_tile.dart';
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
  Room? _room;
  MeetingState _meetingState = const MeetingState();
  Map<String, Participant> participants = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeApp();
      }
    });
  }

  Future<void> _initializeApp() async {
    if (!mounted) return;

    try {
      debugPrint('=== INITIALIZING ENHANCED MEETING SCREEN ===');
      debugPrint('Room ID: ${widget.meetingId}');
      debugPrint('Token: ${widget.token.substring(0, 30)}...');

      _setState(
        _meetingState.copyWith(isInitializing: true, errorMessage: null),
      );

      // Step 1: Check permissions with enhanced handling
      final hasPermissions = await _checkAndRequestPermissions();
      if (!mounted) return;

      if (!hasPermissions) {
        _setState(
          _meetingState.copyWith(
            isInitializing: false,
            errorMessage: 'Camera and microphone permissions are required',
          ),
        );
        _showPermissionDialog();
        return;
      }

      // Step 2: Validate room configuration
      if (widget.meetingId.isEmpty || widget.token.isEmpty) {
        _setState(
          _meetingState.copyWith(
            isInitializing: false,
            errorMessage: 'Invalid room configuration',
          ),
        );
        return;
      }

      // Step 3: Create and join room
      await _createAndJoinRoom();
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        _setState(
          _meetingState.copyWith(
            isInitializing: false,
            errorMessage: 'Failed to join room: ${e.toString()}',
          ),
        );
      }
    }
  }

  void _setState(MeetingState newState) {
    if (mounted) {
      setState(() {
        _meetingState = newState;
      });
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    try {
      debugPrint('Checking permissions...');
      final hasPermissions = await PermissionService.checkPermissions();
      if (hasPermissions) {
        debugPrint('Permissions already granted');
        return true;
      }

      debugPrint('Requesting permissions...');
      final granted =
          await PermissionService.requestCameraAndMicPermissionsWithHandling();
      debugPrint('Permissions granted: $granted');
      return granted;
    } catch (e) {
      debugPrint('Permission error: $e');
      return false;
    }
  }

  Future<void> _createAndJoinRoom() async {
    try {
      debugPrint('Creating VideoSDK room with simple configuration...');

      final room = VideoSDK.createRoom(
        roomId: widget.meetingId,
        token: widget.token,
        displayName: "Phone_Live",
        micEnabled: false,
        camEnabled: false,
        defaultCameraIndex: 0,
      );

      debugPrint('Setting up basic event listeners...');

      // Room joined successfully - ONLY setup after this event
      room.on(Events.roomJoined, () {
        debugPrint('🎉 Room joined successfully!');
        if (!mounted) return;

        setState(() {
          participants[room.localParticipant.id] = room.localParticipant;
        });

        // Sync initial state with VideoSDK
        _syncInitialState(room);

        _setState(_meetingState.copyWith(isInitializing: false));
      });

      // Participant joined - simple handling
      room.on(Events.participantJoined, (participant) {
        debugPrint('👤 Participant joined: ${participant?.id}');
        if (!mounted || participant == null) return;

        setState(() {
          participants[participant.id] = participant;
        });
      });

      // Participant left
      room.on(Events.participantLeft, (participantId) {
        debugPrint('👋 Participant left: $participantId');
        if (!mounted) return;

        setState(() {
          participants.remove(participantId);
        });
      });

      // Room left
      room.on(Events.roomLeft, () {
        debugPrint('🚪 Left the room');
        if (!mounted) return;

        setState(() {
          participants.clear();
        });

        _navigateBack();
      });

      // Error handling
      room.on(Events.error, (error) {
        debugPrint('❌ Room error: $error');
        if (!mounted) return;

        _setState(
          _meetingState.copyWith(
            isInitializing: false,
            errorMessage: 'Connection error: $error',
          ),
        );
      });

      // Store room reference
      _room = room;

      debugPrint('Joining room...');
      room.join();

      // Connection timeout
      Timer(const Duration(seconds: 15), () {
        if (mounted && _meetingState.isInitializing) {
          _setState(
            _meetingState.copyWith(
              isInitializing: false,
              errorMessage: 'Connection timeout. Please try again.',
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Room creation error: $e');
      rethrow;
    }
  }

  void _showPermissionDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Permissions Required'),
            content: const Text(
              'Camera and microphone permissions are required for video calls. '
              'Please enable them in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateBack();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await PermissionService.openDeviceSettings();
                  _initializeApp();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
    );
  }

  // Super responsive control methods with immediate state updates
  void _toggleMic() {
    if (_room == null || _meetingState.isInitializing) return;

    // IMMEDIATE state update for instant UI feedback
    final newMicState = !_meetingState.isMicEnabled;
    _setState(_meetingState.copyWith(isMicEnabled: newMicState));

    try {
      // Perform VideoSDK action based on new state
      if (newMicState) {
        _room!.unmuteMic();
        debugPrint('🎤 Microphone unmuted');
      } else {
        _room!.muteMic();
        debugPrint('🔇 Microphone muted');
      }
    } catch (e) {
      debugPrint('Mic toggle error: $e');
      // Revert state on error
      _setState(_meetingState.copyWith(isMicEnabled: !newMicState));
    }
  }

  void _toggleCamera() {
    if (_room == null || _meetingState.isInitializing) return;

    // IMMEDIATE state update for instant UI feedback
    final newCameraState = !_meetingState.isCameraEnabled;
    _setState(_meetingState.copyWith(isCameraEnabled: newCameraState));

    try {
      // Perform VideoSDK action based on new state
      if (newCameraState) {
        _room!.enableCam();
        debugPrint('📹 Camera enabled');
      } else {
        _room!.disableCam();
        debugPrint('📹 Camera disabled');
      }
    } catch (e) {
      debugPrint('Camera toggle error: $e');
      // Revert state on error
      _setState(_meetingState.copyWith(isCameraEnabled: !newCameraState));
    }
  }

  void _switchCamera() {
    if (_room == null || _meetingState.isInitializing) return;

    // IMMEDIATE state update for instant UI feedback
    final newFrontCameraState = !_meetingState.isFrontCamera;
    _setState(
      _meetingState.copyWith(
        isFrontCamera: newFrontCameraState,
        isFlashEnabled: false, // Turn off flash when switching
      ),
    );

    // Perform camera switch asynchronously
    _performCameraSwitch(newFrontCameraState);
  }

  Future<void> _performCameraSwitch(bool targetFrontCamera) async {
    try {
      final cameras = await VideoSDK.getVideoDevices();
      if (cameras != null && cameras.length >= 2) {
        // Use target state to determine camera index
        final newIndex = targetFrontCamera ? 1 : 0;
        if (newIndex < cameras.length) {
          await _room!.changeCam(cameras[newIndex]);
          debugPrint(
            '📱 Camera switched successfully to ${targetFrontCamera ? 'front' : 'back'}',
          );
        }
      }
    } catch (e) {
      debugPrint('Camera switch error: $e');
      // Revert state on error
      _setState(_meetingState.copyWith(isFrontCamera: !targetFrontCamera));
    }
  }

  void _toggleFlash() {
    if (_meetingState.isFrontCamera || _meetingState.isInitializing) return;

    // IMMEDIATE state update for instant UI feedback
    final newFlashState = !_meetingState.isFlashEnabled;
    _setState(_meetingState.copyWith(isFlashEnabled: newFlashState));

    // Perform flash action asynchronously
    _performFlashToggle(newFlashState);
  }

  Future<void> _performFlashToggle(bool targetState) async {
    try {
      await FlashService.setFlash(targetState);
      debugPrint('💡 Flash ${targetState ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Flash toggle error: $e');
      // Revert state on error
      _setState(_meetingState.copyWith(isFlashEnabled: !targetState));
    }
  }

  void _leaveRoomWithMessage(String message) {
    try {
      _room?.leave();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
        _navigateBack();
      }
    } catch (e) {
      debugPrint('Leave room error: $e');
      _navigateBack();
    }
  }

  void _navigateBack() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const searchActiveFeeds()),
      );
    }
  }

  Future<void> _logout() async {
    try {
      _room?.leave();
      await AuthService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Logout error: $e');
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

  void _syncInitialState(Room room) {
    try {
      // Check actual VideoSDK streams to set initial state
      final hasAudioStream = room.localParticipant.streams.values.any(
        (stream) => stream.kind == 'audio',
      );
      final hasVideoStream = room.localParticipant.streams.values.any(
        (stream) => stream.kind == 'video',
      );

      // Update state to match actual VideoSDK state
      _setState(
        _meetingState.copyWith(
          isMicEnabled: hasAudioStream,
          isCameraEnabled: hasVideoStream,
        ),
      );

      debugPrint(
        '🔄 Initial state synced - Mic: $hasAudioStream, Camera: $hasVideoStream',
      );
    } catch (e) {
      debugPrint('State sync error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _leaveRoomWithMessage('You left the live feed');
        return false;
      },
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
            onPressed: () => _leaveRoomWithMessage('You left the live feed'),
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
        // Enhanced status bar
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Your Live Feed • Broadcasting',
                style: TextStyle(
                  color: AppTheme.textPrimaryColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Enhanced video area
        Expanded(child: _buildVideoArea()),
        SizedBox(height: 16.h),

        // Enhanced controls
        EnhancedMeetingControls(
          onToggleMicButtonPressed: _toggleMic,
          onToggleCameraButtonPressed: _toggleCamera,
          onSwitchCameraButtonPressed: _switchCamera,
          onToggleFlashButtonPressed: _toggleFlash,
          onLeaveButtonPressed:
              () => _leaveRoomWithMessage('You left the live feed'),
          isMicEnabled: _isMicEnabled(),
          isCameraEnabled: _isCameraEnabled(),
          isFrontCamera: _meetingState.isFrontCamera,
          isFlashEnabled: _meetingState.isFlashEnabled,
        ),
      ],
    );
  }

  Widget _buildVideoArea() {
    // Show local participant if available
    if (participants.isNotEmpty && _room != null) {
      final localParticipant = participants[_room!.localParticipant.id];
      if (localParticipant != null) {
        return EnhancedParticipantTile(
          key: Key(localParticipant.id),
          participant: localParticipant,
          isLocalParticipant: true,
        );
      }
    }

    // Fallback UI
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2.w,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isCameraEnabled() ? Icons.videocam : Icons.videocam_off,
              size: 80.sp,
              color:
                  _isCameraEnabled()
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
            ),
            SizedBox(height: 16.h),
            Text(
              _isCameraEnabled()
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
              _isCameraEnabled()
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
      ),
    );
  }

  bool _isMicEnabled() {
    // Use immediate state for instant UI feedback
    return _meetingState.isMicEnabled;
  }

  bool _isCameraEnabled() {
    // Use immediate state for instant UI feedback
    return _meetingState.isCameraEnabled;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                ElevatedButton(
                  onPressed: _navigateBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
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
            'Setting up your camera and microphone...',
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
    try {
      _room?.leave();
    } catch (e) {
      debugPrint('Error leaving room on dispose: $e');
    }
    super.dispose();
  }
}
