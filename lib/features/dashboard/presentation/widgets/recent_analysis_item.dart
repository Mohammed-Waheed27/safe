import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Widget for displaying a recent analysis item
class RecentAnalysisItem extends StatelessWidget {
  /// Title of the analysis
  final String title;

  /// Date when the analysis was conducted
  final String date;

  /// Type of analysis (Image, Video, Live)
  final String type;

  /// Count of people detected
  final int count;

  /// Constructor
  const RecentAnalysisItem({
    super.key,
    required this.title,
    required this.date,
    required this.type,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          // Left section with title and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Right section with type and count
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Icon(_getTypeIcon(), size: 16.sp, color: AppTheme.primaryColor),
                SizedBox(width: 6.w),
                Text(
                  '$count people',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Get the appropriate icon based on analysis type
  IconData _getTypeIcon() {
    switch (type.toLowerCase()) {
      case 'image':
        return Icons.image_outlined;
      case 'video':
        return Icons.videocam_outlined;
      case 'live':
        return Icons.stream_outlined;
      default:
        return Icons.analytics_outlined;
    }
  }
}
