import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ru2ya/features/mobiel%20cam%20feed/data/api_call.dart';
import 'package:videosdk/videosdk.dart';
import '../../../participant_tile.dart';
import '../../../meeting_controls.dart';

class LiveFeedView extends StatefulWidget {
  final String meetingId;
  final String token;

  const LiveFeedView({super.key, required this.meetingId, required this.token});

  @override
  State<LiveFeedView> createState() => _LiveFeedViewState();
}

class _LiveFeedViewState extends State<LiveFeedView> {
  late Room _room;
  var micEnabled = false;
  var camEnabled = false;

  Map<String, Participant> participants = {};

  @override
  void initState() {
    // create room
    _room = VideoSDK.createRoom(
      roomId: widget.meetingId,
      token: widget.token,
      displayName: "John Doe",
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

    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setMeetingEventListener() {
    _room.on(Events.roomJoined, () {
      // Remove this line to prevent host from being added
      // participants.putIfAbsent(...)
    });

    _room.on(Events.participantJoined, (Participant participant) {
      // Add conditional check
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
      deleteFeed();
    });
  }

  // onbackButton pressed leave the room
  Future<bool> _onWillPop() async {
    _room.leave();
    Navigator.pop(context);
    deleteFeed();
    return true;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Phone Feeds'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("the server id is : ${widget.meetingId}"),
              //render all participant
              participants.length == 0
                  ? const Expanded(
                    child: Center(
                      child: Text("""No participants connected  in the moment
  other partticipants can connect now .... """),
                    ),
                  )
                  : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 300,
                            ),
                        itemBuilder: (context, index) {
                          return ParticipantTile(
                            key: Key(participants.values.elementAt(index).id),
                            participant: participants.values.elementAt(index),
                          );
                        },
                        itemCount: participants.length,
                      ),
                    ),
                  ),
              participants.length == 0 ? Spacer() : SizedBox(),
              MeetingControls(
                onLeaveButtonPressed: () {
                  _room.leave();
                  Navigator.pop(context);
                  deleteFeed();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
