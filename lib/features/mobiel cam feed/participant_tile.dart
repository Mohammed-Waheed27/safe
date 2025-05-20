import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  const ParticipantTile({super.key, required this.participant});

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;

  @override
  void initState() {
    // initial video stream for the participant
    widget.participant.streams.forEach((key, Stream stream) {
      setState(() {
        if (stream.kind == 'video') {
          videoStream = stream;
        }
      });
    });
    _initStreamListeners();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = stream);
      }
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child:
          videoStream != null
              ? RTCVideoView(
                videoStream?.renderer as RTCVideoRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              )
              : Container(
                color: Colors.grey.shade800,
                child: const Center(child: Icon(Icons.person, size: 100)),
              ),
    );
  }
}
