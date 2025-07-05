import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

class ZoneControls extends StatelessWidget {
  final VoidCallback onLeaveSession;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCamera;
  final bool isMicEnabled;
  final bool isCameraEnabled;

  const ZoneControls({
    super.key,
    required this.onLeaveSession,
    required this.onToggleMic,
    required this.onToggleCamera,
    required this.isMicEnabled,
    required this.isCameraEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: isMicEnabled ? Icons.mic : Icons.mic_off,
          label: isMicEnabled ? 'Mute' : 'Unmute',
          onPressed: onToggleMic,
          backgroundColor: isMicEnabled ? null : Colors.red,
        ),
        _buildControlButton(
          icon: isCameraEnabled ? Icons.videocam : Icons.videocam_off,
          label: isCameraEnabled ? 'Stop Video' : 'Start Video',
          onPressed: onToggleCamera,
          backgroundColor: isCameraEnabled ? null : Colors.red,
        ),
        _buildControlButton(
          icon: Icons.call_end,
          label: 'End Session',
          onPressed: onLeaveSession,
          backgroundColor: Colors.red,
        ),
      ],
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
