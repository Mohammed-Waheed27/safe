import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main controls row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Microphone Button
              _buildMainControlButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onToggleMicButtonPressed();
                },
                icon: isMicEnabled ? Icons.mic : Icons.mic_off,
                isActive: isMicEnabled,
                label: 'Mic',
              ),

              // Camera Button
              _buildMainControlButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onToggleCameraButtonPressed();
                },
                icon: isCameraEnabled ? Icons.videocam : Icons.videocam_off,
                isActive: isCameraEnabled,
                label: 'Camera',
              ),

              // Leave Button
              _buildLeaveButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  onLeaveButtonPressed();
                },
              ),
            ],
          ),

          // Secondary controls (only show if camera is enabled)
          if (isCameraEnabled) ...[
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera Switch Button
                _buildSecondaryControlButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    onSwitchCameraButtonPressed();
                  },
                  icon: isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                  label: isFrontCamera ? 'Front' : 'Back',
                  isActive: true,
                ),

                // Flash Button (only for back camera)
                if (!isFrontCamera && onToggleFlashButtonPressed != null) ...[
                  SizedBox(width: 24.w),
                  _buildSecondaryControlButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onToggleFlashButtonPressed!();
                    },
                    icon: isFlashEnabled ? Icons.flash_on : Icons.flash_off,
                    label: 'Flash',
                    isActive: isFlashEnabled,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required bool isActive,
    required String label,
  }) {
    final Color activeColor = Colors.green;
    final Color inactiveColor = Colors.red;
    final Color currentColor = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50), // Super fast animation
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: currentColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: currentColor, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: currentColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: currentColor, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: currentColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    final Color activeColor = Colors.blue;
    final Color flashColor = Colors.amber;
    final Color inactiveColor = Colors.grey;

    // Special handling for flash button
    final Color currentColor =
        label == 'Flash'
            ? (isActive ? flashColor : inactiveColor)
            : activeColor;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50), // Super fast animation
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: currentColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: currentColor.withOpacity(0.6),
            width: 1.5.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: currentColor, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: currentColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveButton({required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.red, Color(0xFFD32F2F)],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.call_end, color: Colors.white, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              'Leave',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
