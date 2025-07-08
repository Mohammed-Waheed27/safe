import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/appthme.dart';

class EnhancedMeetingControls extends StatelessWidget {
  final VoidCallback onToggleMicButtonPressed;
  final VoidCallback onToggleCameraButtonPressed;
  final VoidCallback onSwitchCameraButtonPressed;
  final VoidCallback? onToggleFlashButtonPressed;
  final VoidCallback onLeaveButtonPressed;
  final bool isMicEnabled;
  final bool isCameraEnabled;
  final bool isFrontCamera;
  final bool isFlashEnabled;

  const EnhancedMeetingControls({
    super.key,
    required this.onToggleMicButtonPressed,
    required this.onToggleCameraButtonPressed,
    required this.onSwitchCameraButtonPressed,
    this.onToggleFlashButtonPressed,
    required this.onLeaveButtonPressed,
    required this.isMicEnabled,
    required this.isCameraEnabled,
    required this.isFrontCamera,
    this.isFlashEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            onPressed: onToggleMicButtonPressed,
            icon: Icon(
              isMicEnabled ? Icons.mic : Icons.mic_off,
              color: isMicEnabled ? AppTheme.textPrimaryColor : Colors.red,
              size: 24.sp,
            ),
            isActive: isMicEnabled,
          ),
          _buildControlButton(
            onPressed: onToggleCameraButtonPressed,
            icon: Icon(
              isCameraEnabled ? Icons.videocam : Icons.videocam_off,
              color: isCameraEnabled ? AppTheme.textPrimaryColor : Colors.red,
              size: 24.sp,
            ),
            isActive: isCameraEnabled,
          ),
          if (isCameraEnabled) ...[
            _buildControlButton(
              onPressed: onSwitchCameraButtonPressed,
              icon: Icon(
                isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                color: AppTheme.textPrimaryColor,
                size: 24.sp,
              ),
              isActive: true,
            ),
            if (onToggleFlashButtonPressed != null && !isFrontCamera)
              _buildControlButton(
                onPressed: onToggleFlashButtonPressed!,
                icon: Icon(
                  isFlashEnabled ? Icons.flash_on : Icons.flash_off,
                  color:
                      isFlashEnabled
                          ? Colors.yellow
                          : AppTheme.textPrimaryColor,
                  size: 24.sp,
                ),
                isActive: true,
              ),
          ],
          _buildControlButton(
            onPressed: onLeaveButtonPressed,
            icon: Icon(Icons.call_end, color: Colors.white, size: 24.sp),
            isActive: true,
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget icon,
    required bool isActive,
    Color? backgroundColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isActive ? AppTheme.primaryColor : Colors.grey.shade600),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: icon,
      ),
    );
  }
}
