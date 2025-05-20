import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miun_live/features/live%20feed/pages/search%20rooms/search_active_feeds.dart';
import 'package:videosdk/videosdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import './participant_tile.dart';
import 'meeting_controls.dart';
import 'core/theme/appthme.dart';
import 'api_call.dart';

class MeetingScreen extends StatefulWidget {
  final String meetingId;
  final String token;

  const MeetingScreen({
    super.key,
    required this.meetingId,
    required this.token,
  });

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  late Room _room;
  var micEnabled = true;
  var camEnabled = true;
  bool isInitializing = true;
  String? errorMessage;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;

  Map<String, Participant> participants = {};

  @override
  void initState() {
    super.initState();
    _initializeRoom();
    _startRoomMonitoring();
  }

  void _initializeRoom() {
    try {
      setState(() {
        isInitializing = true;
        errorMessage = null;
      });

      _room = VideoSDK.createRoom(
        roomId: widget.meetingId,
        token: widget.token,
        displayName: "Phone_Live",
        micEnabled: micEnabled,
        camEnabled: camEnabled,
        defaultCameraIndex: 0, // Always use back camera (index 0)
      );

      setMeetingEventListener();
      _room.join();

      setState(() {
        isInitializing = false;
      });
    } catch (e) {
      setState(() {
        isInitializing = false;
        errorMessage = 'Failed to initialize room: ${e.toString()}';
      });
      _leaveRoomWithMessage('Failed to join the room');
    }
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

  void setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      if (!mounted) return;
      setState(() {
        participants.putIfAbsent(
          _room.localParticipant.id,
          () => _room.localParticipant,
        );
      });
    });

    _room.on(Events.participantJoined, (Participant participant) {
      if (!mounted || participant.id != _room.localParticipant.id) return;
      setState(() {
        participants.putIfAbsent(participant.id, () => participant);
      });
    });

    _room.on(Events.participantLeft, (String participantId) {
      if (!mounted || !participants.containsKey(participantId)) return;
      setState(() {
        participants.remove(participantId);
      });
    });

    _room.on(Events.roomLeft, () {
      if (!mounted) return;
      participants.clear();
      Navigator.pop(context);
    });

    _room.on(Events.error, (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Room error: ${error.toString()}';
      });
      _leaveRoomWithMessage('An error occurred in the room');
    });
  }

  Future<bool> _onWillPop() async {
    _leaveRoomWithMessage('You left the live feed');
    return true;
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
            style: TextStyle(color: AppTheme.textPrimaryColor, fontSize: 20.sp),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
            onPressed: () => _onWillPop(),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (errorMessage != null)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (isInitializing)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppTheme.primaryColor),
                      SizedBox(height: 16.h),
                      Text(
                        'Connecting to room...',
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Expanded(
                      child:
                          participants.isEmpty
                              ? Center(
                                child: Text(
                                  'No video stream available',
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              )
                              : ParticipantTile(
                                key: Key(participants.values.first.id),
                                participant: participants.values.first,
                              ),
                    ),
                    MeetingControls(
                      onToggleMicButtonPressed: () {
                        setState(() {
                          micEnabled = !micEnabled;
                          micEnabled ? _room.unmuteMic() : _room.muteMic();
                        });
                      },
                      onToggleCameraButtonPressed: () {
                        setState(() {
                          camEnabled = !camEnabled;
                          camEnabled ? _room.enableCam() : _room.disableCam();
                        });
                      },
                      onLeaveButtonPressed:
                          () => _leaveRoomWithMessage('You left the live feed'),
                      isMicEnabled: micEnabled,
                      isCameraEnabled: camEnabled,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    _room.leave();
    super.dispose();
  }
}
