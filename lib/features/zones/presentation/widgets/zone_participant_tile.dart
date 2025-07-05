import 'package:flutter/material.dart';
import 'package:videosdk/videosdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

class ZoneParticipantTile extends StatefulWidget {
  final Participant participant;

  const ZoneParticipantTile({Key? key, required this.participant})
    : super(key: key);

  @override
  State<ZoneParticipantTile> createState() => _ZoneParticipantTileState();
}

class _ZoneParticipantTileState extends State<ZoneParticipantTile> {
  Stream? videoStream;
  bool isMicOn = false;

  @override
  void initState() {
    super.initState();
    print('Initializing participant tile: ${widget.participant.id}');
    _initializeParticipant();
  }

  void _initializeParticipant() {
    try {
      // Check initial streams
      widget.participant.streams.forEach((key, Stream stream) {
        setState(() {
          if (stream.kind == 'video') {
            print(
              'Found video stream for participant: ${widget.participant.id}',
            );
            videoStream = stream;
          } else if (stream.kind == 'audio') {
            print(
              'Found audio stream for participant: ${widget.participant.id}',
            );
            isMicOn = true;
          }
        });
      });

      // Listen for stream enabled/disabled events
      widget.participant.on(Events.streamEnabled, (Stream stream) {
        print(
          'Stream enabled: ${stream.kind} for participant: ${widget.participant.id}',
        );
        setState(() {
          if (stream.kind == 'video') {
            videoStream = stream;
          } else if (stream.kind == 'audio') {
            isMicOn = true;
          }
        });
      });

      widget.participant.on(Events.streamDisabled, (Stream stream) {
        print(
          'Stream disabled: ${stream.kind} for participant: ${widget.participant.id}',
        );
        setState(() {
          if (stream.kind == 'video') {
            videoStream = null;
          } else if (stream.kind == 'audio') {
            isMicOn = false;
          }
        });
      });
    } catch (e) {
      print('Error initializing participant tile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Video view
          Positioned.fill(
            child:
                videoStream != null
                    ? RTCVideoView(
                      videoStream!.renderer as RTCVideoRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    )
                    : Container(
                      color: AppTheme.backgroundColor,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam_off,
                              size: 48.sp,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Camera Off',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),

          // Participant info overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.participant.displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isMicOn ? Icons.mic : Icons.mic_off,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('Disposing participant tile: ${widget.participant.id}');
    super.dispose();
  }
}
