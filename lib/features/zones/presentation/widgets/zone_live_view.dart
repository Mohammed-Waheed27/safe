import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/zone_model.dart';
import '../widgets/zone_participant_tile.dart';
import '../widgets/zone_controls.dart';
import '../../../../core/config/app_theme.dart';
import '../bloc/zone_bloc.dart';

class ZoneLiveView extends StatefulWidget {
  final ZoneModel zone;
  final String token;
  final String roomId;

  const ZoneLiveView({
    Key? key,
    required this.zone,
    required this.token,
    required this.roomId,
  }) : super(key: key);

  @override
  State<ZoneLiveView> createState() => _ZoneLiveViewState();
}

class _ZoneLiveViewState extends State<ZoneLiveView> {
  late Room _room;
  bool isMicEnabled = false;
  bool isCameraEnabled = false;
  Map<String, Participant> participants = {};

  @override
  void initState() {
    super.initState();
    print('Initializing ZoneLiveView with roomId: ${widget.roomId}');
    _initializeRoom();
  }

  void _initializeRoom() {
    try {
      print('Creating room with token: ${widget.token}');
      _room = VideoSDK.createRoom(
        roomId: widget.roomId,
        token: widget.token,
        displayName: "Zone Monitor",
        micEnabled: isMicEnabled,
        camEnabled: isCameraEnabled,
        defaultCameraIndex: 1, // Use back camera by default
      );

      _setMeetingEventListener();
      print('Joining room...');
      _room.join();

      // Create active zone feed record
      _createZoneFeedId(widget.roomId);
    } catch (e) {
      print('Error initializing room: $e');
      _showErrorSnackBar('Failed to initialize video session: $e');
    }
  }

  void _setMeetingEventListener() {
    try {
      _room.on(Events.roomJoined, () {
        print('Room joined successfully');
      });

      _room.on(Events.participantJoined, (Participant participant) {
        print('Participant joined: ${participant.id}');
        if (participant.id != _room.localParticipant?.id) {
          setState(
            () => participants.putIfAbsent(participant.id, () => participant),
          );
        }
      });

      _room.on(Events.participantLeft, (String participantId) {
        print('Participant left: $participantId');
        if (participants.containsKey(participantId)) {
          setState(() => participants.remove(participantId));
        }
      });

      _room.on(Events.roomLeft, () {
        print('Room left');
        participants.clear();
        _deleteZoneFeed();
        if (mounted) {
          Navigator.pop(context);
        }
      });

      _room.on(Events.error, (error) {
        print('Room error: $error');
        _showErrorSnackBar('Video session error: $error');
      });
    } catch (e) {
      print('Error setting up event listeners: $e');
    }
  }

  Future<void> _createZoneFeedId(String roomId) async {
    try {
      print('Creating zone feed record...');
      await FirebaseFirestore.instance
          .collection("active_zone_feeds")
          .doc('zone_feed_$roomId')
          .set({
            "roomId": roomId,
            "zoneId": widget.zone.zoneId,
            "createdAt": FieldValue.serverTimestamp(),
          });
      print('Zone feed record created successfully');
    } catch (e) {
      print('Error creating zone feed record: $e');
    }
  }

  Future<void> _deleteZoneFeed() async {
    try {
      print('Deleting zone feed record...');
      await FirebaseFirestore.instance
          .collection("active_zone_feeds")
          .doc('zone_feed_${widget.roomId}')
          .delete();
      print('Zone feed record deleted successfully');
    } catch (e) {
      print('Error deleting zone feed record: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    print('Leaving room...');
    _room.leave();

    // Dispatch end video session to update Firestore/Bloc state
    if (mounted) {
      try {
        context.read<ZoneBloc>().add(EndVideoSession());
      } catch (e) {
        print('Error dispatching EndVideoSession: $e');
      }
    }

    await _deleteZoneFeed();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppTheme.surfaceColor,
          title: Text('${widget.zone.name} Live'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 25.h),
          child: Column(
            children: [
              // Zone info header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Text(
                      "Zone Server ID: ${widget.roomId}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoChip(
                          'Capacity',
                          '${widget.zone.currentCount}/${widget.zone.maximumCount}',
                        ),
                        _buildInfoChip('Threshold', '${widget.zone.threshold}'),
                        _buildInfoChip(
                          'Participants',
                          participants.length.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Participants grid
              Expanded(
                child:
                    participants.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_off_outlined,
                                size: 48.sp,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No participants connected\nWaiting for devices to join...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        )
                        : GridView.builder(
                          padding: EdgeInsets.all(8.w),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 3 / 4,
                              ),
                          itemCount: participants.length,
                          itemBuilder: (context, index) {
                            return ZoneParticipantTile(
                              key: Key(participants.values.elementAt(index).id),
                              participant: participants.values.elementAt(index),
                            );
                          },
                        ),
              ),

              // Controls
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ZoneControls(
                  isMicEnabled: isMicEnabled,
                  isCameraEnabled: isCameraEnabled,
                  onToggleMic: () {
                    setState(() {
                      isMicEnabled = !isMicEnabled;
                      if (isMicEnabled) {
                        _room.unmuteMic();
                      } else {
                        _room.muteMic();
                      }
                    });
                  },
                  onToggleCamera: () {
                    setState(() {
                      isCameraEnabled = !isCameraEnabled;
                      if (isCameraEnabled) {
                        _room.enableCam();
                      } else {
                        _room.disableCam();
                      }
                    });
                  },
                  onLeaveSession: () {
                    _room.leave();

                    // Notify Bloc to end video session
                    try {
                      context.read<ZoneBloc>().add(EndVideoSession());
                    } catch (e) {
                      print('Error dispatching EndVideoSession: $e');
                    }

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('Disposing ZoneLiveView');
    super.dispose();
  }
}
