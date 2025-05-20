import 'package:flutter/material.dart';

class MeetingControls extends StatelessWidget {
  final void Function() onLeaveButtonPressed;

  const MeetingControls({super.key, required this.onLeaveButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onLeaveButtonPressed,
          child: const Text('close the feed server'),
        ),
      ],
    );
  }
}
