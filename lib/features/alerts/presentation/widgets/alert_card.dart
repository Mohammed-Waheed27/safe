import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Different types of alerts
enum AlertType { capacity, growth, density, approaching, flow }

/// A card widget for displaying alert information
class AlertCard extends StatelessWidget {
  /// Title of the alert
  final String title;

  /// Time when the alert occurred
  final String time;

  /// Current value that triggered the alert
  final String value;

  /// Threshold value for the alert
  final String threshold;

  /// Whether the alert is currently active
  final bool isActive;

  /// Type of alert
  final AlertType type;

  /// Callback when the alert is dismissed
  final VoidCallback onDismiss;

  /// Constructor
  const AlertCard({
    super.key,
    required this.title,
    required this.time,
    required this.value,
    required this.threshold,
    required this.isActive,
    required this.type,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border:
            isActive ? Border.all(color: _getAlertColor(), width: 1.5) : null,
      ),
      child: Column(
        children: [
          // Alert header with status indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? _getAlertColor().withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                // Alert type icon
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: _getAlertColor().withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getAlertIcon(),
                      size: 18.sp,
                      color: _getAlertColor(),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Alert title and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? _getAlertColor().withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: isActive ? _getAlertColor() : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        isActive ? 'Active' : 'Resolved',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isActive ? _getAlertColor() : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: Colors.white.withOpacity(0.05)),

          // Alert details and actions
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Values and threshold
                Expanded(
                  child: Row(
                    children: [
                      // Current value
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Value',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isActive ? _getAlertColor() : Colors.white,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 24.w),

                      // Threshold value
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Threshold',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            threshold,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // View details action
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        size: 20.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      tooltip: 'View Details',
                    ),
                    IconButton(
                      onPressed: onDismiss,
                      icon: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      tooltip: 'Dismiss',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get the appropriate color for the alert type
  Color _getAlertColor() {
    switch (type) {
      case AlertType.capacity:
        return AppTheme.errorColor;
      case AlertType.growth:
        return AppTheme.warningColor;
      case AlertType.density:
        return AppTheme.errorColor;
      case AlertType.approaching:
        return AppTheme.warningColor;
      case AlertType.flow:
        return AppTheme.primaryColor;
    }
  }

  /// Get the appropriate icon for the alert type
  IconData _getAlertIcon() {
    switch (type) {
      case AlertType.capacity:
        return Icons.people_outlined;
      case AlertType.growth:
        return Icons.trending_up;
      case AlertType.density:
        return Icons.groups_outlined;
      case AlertType.approaching:
        return Icons.warning_amber_outlined;
      case AlertType.flow:
        return Icons.speed_outlined;
    }
  }
}
