import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Card widget for displaying summary statistics on the dashboard
class DashboardCard extends StatelessWidget {
  /// Card title text
  final String title;

  /// Main value to display
  final String value;

  /// Description text (e.g. time period)
  final String description;

  /// Trend information
  final String trend;

  /// Whether the trend is positive, negative, or neutral
  final bool? isTrendPositive;

  /// Optional icon to display
  final IconData? icon;

  /// Constructor
  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.description,
    required this.trend,
    this.isTrendPositive,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (icon != null)
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),

          // Main value
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 4.h),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),

          SizedBox(height: 16.h),

          // Trend indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getTrendColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isTrendPositive != null)
                  Icon(
                    isTrendPositive == true
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 12.sp,
                    color: _getTrendColor(),
                  ),
                SizedBox(width: 4.w),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: _getTrendColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get the appropriate color for the trend indicator
  Color _getTrendColor() {
    if (isTrendPositive == null) return AppTheme.textSecondaryColor;
    return isTrendPositive == true
        ? AppTheme.successColor
        : AppTheme.errorColor;
  }
}
