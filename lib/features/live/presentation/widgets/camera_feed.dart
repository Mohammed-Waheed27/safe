import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Widget that displays a camera feed with status information
class CameraFeed extends StatelessWidget {
  /// Name of the camera
  final String cameraName;

  /// Number of people detected in the camera view
  final int peopleCount;

  /// Whether the camera is currently online
  final bool isOnline;

  /// Whether there's an active alert for this camera
  final bool hasAlert;

  /// Whether this feed is shown in fullscreen/single view
  final bool isFullscreen;

  /// Constructor
  const CameraFeed({
    super.key,
    required this.cameraName,
    required this.peopleCount,
    required this.isOnline,
    required this.hasAlert,
    this.isFullscreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border:
            hasAlert ? Border.all(color: AppTheme.errorColor, width: 2) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Camera feed - using placeholder gradient for demo
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.brown.shade900.withOpacity(0.8),
                  Colors.brown.shade800.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Camera name and status
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      cameraName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isFullscreen ? 16.sp : 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isOnline ? 'online' : 'offline',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isFullscreen ? 14.sp : 10.sp,
                      ),
                    ),
                    if (hasAlert) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Alert',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isFullscreen ? 12.sp : 9.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // People count
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: isFullscreen ? 20.sp : 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  peopleCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isFullscreen ? 16.sp : 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Camera controls (only visible on hover in a real app)
          if (isFullscreen)
            Positioned(
              bottom: 12.h,
              right: 12.w,
              child: Row(
                children: [
                  _buildControlButton(Icons.play_arrow),
                  SizedBox(width: 8.w),
                  _buildControlButton(Icons.pause),
                  SizedBox(width: 8.w),
                  _buildControlButton(Icons.download),
                  SizedBox(width: 8.w),
                  _buildControlButton(Icons.fullscreen_exit),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16.sp),
    );
  }
}
