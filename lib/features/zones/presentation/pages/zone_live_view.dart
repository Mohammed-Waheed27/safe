import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:videosdk/videosdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_theme.dart';
import '../../../zones/presentation/pages/zones_page.dart';
import '../../data/models/zone_model.dart';
import '../bloc/zone_bloc.dart';
import '../widgets/zone_participant_tile.dart';

/// Zone Live View - exactly like mobile cam feed functionality
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
  var micEnabled = false;
  var camEnabled = false;

  Map<String, Participant> participants = {};

  @override
  void initState() {
    super.initState();
    // Create room using same approach as mobile cam feed
    _room = VideoSDK.createRoom(
      roomId: widget.roomId,
      token: widget.token,
      displayName: "Zone Monitor", // Display name for zone monitoring
      micEnabled: micEnabled,
      camEnabled: camEnabled,
      defaultCameraIndex:
          kIsWeb
              ? 0
              : 1, // Index of MediaDevices will be used to set default camera
    );

    setMeetingEventListener();

    // Join room
    _room.join();

    // Create feed ID in Firestore like mobile cam feed
    createZoneFeedId(widget.roomId);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      // Similar to mobile cam feed - don't add host to participants
    });

    _room.on(Events.participantJoined, (Participant participant) {
      // Add conditional check like mobile cam feed
      if (participant.id != _room.localParticipant?.id) {
        setState(
          () => participants.putIfAbsent(participant.id, () => participant),
        );
      }
    });

    _room.on(Events.participantLeft, (String participantId) {
      if (participants.containsKey(participantId)) {
        setState(() => participants.remove(participantId));
      }
    });

    _room.on(Events.roomLeft, () {
      participants.clear();
      Navigator.pop(context);
      deleteZoneFeed();
    });
  }

  // Create zone feed ID like mobile cam feed
  Future<void> createZoneFeedId(String roomId) async {
    await FirebaseFirestore.instance
        .collection("active_zone_feeds")
        .doc('zone_feed_$roomId')
        .set({
          "roomId": roomId,
          "zoneId": widget.zone.zoneId,
          "createdAt": FieldValue.serverTimestamp(),
        });
  }

  // Clean up zone feed like mobile cam feed
  Future<void> deleteZoneFeed() async {
    try {
      await FirebaseFirestore.instance
          .collection("active_zone_feeds")
          .doc('zone_feed_${widget.roomId}')
          .delete();
    } catch (e) {
      print('Error deleting zone feed: $e');
    }
  }

  // onbackButton pressed leave the room
  Future<bool> _onWillPop() async {
    _room.leave();
    Navigator.pop(context);
    deleteZoneFeed();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Zone info header similar to mobile cam feed server ID display
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
                        _buildInfoChip('Status', 'Live'),
                      ],
                    ),
                  ],
                ),
              ),

              // Participants display exactly like mobile cam feed
              participants.isEmpty
                  ? Expanded(
                    child: Center(
                      child: Text(
                        """No participants connected at the moment
other participants can connect now.....""",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  )
                  : Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 300,
                            ),
                        itemBuilder: (context, index) {
                          return ZoneParticipantTile(
                            key: Key(participants.values.elementAt(index).id),
                            participant: participants.values.elementAt(index),
                          );
                        },
                        itemCount: participants.length,
                      ),
                    ),
                  ),

              // Add spacer like mobile cam feed when no participants
              participants.isEmpty ? const Spacer() : const SizedBox(),

              // Control buttons exactly like mobile cam feed
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: micEnabled ? Icons.mic : Icons.mic_off,
                      label: micEnabled ? 'Mute' : 'Unmute',
                      onPressed: () {
                        setState(() {
                          micEnabled = !micEnabled;
                          if (micEnabled) {
                            _room.unmuteMic();
                          } else {
                            _room.muteMic();
                          }
                        });
                      },
                      backgroundColor: micEnabled ? null : Colors.red,
                    ),
                    _buildControlButton(
                      icon: camEnabled ? Icons.videocam : Icons.videocam_off,
                      label: camEnabled ? 'Stop Video' : 'Start Video',
                      onPressed: () {
                        setState(() {
                          camEnabled = !camEnabled;
                          if (camEnabled) {
                            _room.enableCam();
                          } else {
                            _room.disableCam();
                          }
                        });
                      },
                      backgroundColor: camEnabled ? null : Colors.red,
                    ),
                    _buildControlButton(
                      icon: Icons.call_end,
                      label: 'Close the feed server',
                      onPressed: () {
                        context.read<ZoneBloc>().add(EndVideoSession());

                        _room.leave();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ZonesPage()),
                        );
                        deleteZoneFeed();
                      },
                      backgroundColor: Colors.red,
                    ),
                  ],
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

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          margin: EdgeInsets.only(bottom: 4.h),
          child: MaterialButton(
            onPressed: onPressed,
            color: backgroundColor ?? AppTheme.surfaceColor.withOpacity(0.8),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
