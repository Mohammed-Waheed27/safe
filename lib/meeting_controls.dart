import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/appthme.dart';

class MeetingControls extends StatelessWidget {
  final VoidCallback onToggleMicButtonPressed;
  final VoidCallback onToggleCameraButtonPressed;
  final VoidCallback onLeaveButtonPressed;
  final bool isMicEnabled;
  final bool isCameraEnabled;

  const MeetingControls({
    super.key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onLeaveButtonPressed,
    required this.isMicEnabled,
    required this.isCameraEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            onPressed: onToggleMicButtonPressed,
            icon: Icon(
              isMicEnabled ? Icons.mic : Icons.mic_off,
              color: AppTheme.textPrimaryColor,
              size: 24.sp,
            ),
          ),
          _buildControlButton(
            onPressed: onToggleCameraButtonPressed,
            icon: Icon(
              isCameraEnabled ? Icons.videocam : Icons.videocam_off,
              color: AppTheme.textPrimaryColor,
              size: 24.sp,
            ),
          ),
          _buildControlButton(
            onPressed: onLeaveButtonPressed,
            icon: Icon(Icons.call_end, color: Colors.red, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: icon,
      ),
    );
  }
}
