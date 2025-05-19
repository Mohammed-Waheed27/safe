import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_theme.dart';

/// Widget for displaying the current status of a monitored zone
class StatusWidget extends StatelessWidget {
  /// Name of the zone
  final String zoneName;

  /// Current people count
  final int peopleCount;

  /// Current occupancy percentage (0-100)
  final int currentOccupancy;

  /// Alert threshold percentage (0-100)
  final int alertThreshold;

  /// Number of cameras in the zone
  final int cameraCount;

  /// Status text (e.g., "Normal", "Alert")
  final String status;

  /// Last updated timestamp
  final DateTime timestamp;

  /// Constructor
  const StatusWidget({
    super.key,
    required this.zoneName,
    required this.peopleCount,
    required this.currentOccupancy,
    required this.alertThreshold,
    required this.cameraCount,
    required this.status,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(timestamp);
    final dateString = DateFormat('yyyy-MM-dd').format(timestamp);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Current Status',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getStatusColor(),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Zone information
          Text(
            'Zone: $zoneName',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 16.h),

          // People count with big number
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                peopleCount.toString(),
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'People detected',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Current occupancy
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current occupancy',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '$currentOccupancy%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: currentOccupancy / 100,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  color: _getOccupancyColor(),
                  minHeight: 8.h,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Alert threshold
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alert threshold',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '$alertThreshold%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: Container(
                      height: 8.h,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    left: (alertThreshold / 100) * 100.w,
                    child: Container(
                      width: 2.w,
                      height: 8.h,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Footer info
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.videocam_outlined,
                      size: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$cameraCount cameras',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      timeString,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Get color based on status
  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'alert':
        return AppTheme.errorColor;
      case 'warning':
        return AppTheme.warningColor;
      case 'normal':
      default:
        return AppTheme.successColor;
    }
  }

  /// Get color based on occupancy percentage
  Color _getOccupancyColor() {
    if (currentOccupancy >= 90) {
      return AppTheme.errorColor;
    } else if (currentOccupancy >= alertThreshold) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.successColor;
    }
  }
}
