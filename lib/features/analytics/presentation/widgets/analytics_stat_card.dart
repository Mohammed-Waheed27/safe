import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Card widget for displaying analytics statistics
class AnalyticsStatCard extends StatelessWidget {
  /// Title of the statistic
  final String title;

  /// Main value to display
  final String value;

  /// Subtitle or supporting text
  final String subtitle;

  /// Optional trend percentage
  final double? trend;

  /// Constructor
  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.trend,
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
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          SizedBox(height: 12.h),

          // Main value
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8.h),

          // Subtitle with optional trend
          Row(
            children: [
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              if (trend != null) ...[
                SizedBox(width: 8.w),
                _buildTrendIndicator(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Build the trend indicator
  Widget _buildTrendIndicator() {
    final isPositive = trend! > 0;
    final color = isPositive ? AppTheme.successColor : AppTheme.errorColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 2.w),
          Text(
            '${trend!.abs()}%',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
