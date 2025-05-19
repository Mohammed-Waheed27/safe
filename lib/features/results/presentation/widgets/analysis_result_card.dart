import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// A card widget for displaying analysis results
class AnalysisResultCard extends StatelessWidget {
  /// Location where the analysis was performed
  final String location;

  /// Date of the analysis
  final String date;

  /// Time of the analysis
  final String time;

  /// Number of people counted
  final int peopleCount;

  /// Accuracy percentage of the analysis
  final double accuracy;

  /// Type of analysis (Image, Video, Live)
  final String type;

  /// Callback when download is requested
  final VoidCallback onDownload;

  /// Callback when sharing is requested
  final VoidCallback onShare;

  /// Constructor
  const AnalysisResultCard({
    super.key,
    required this.location,
    required this.date,
    required this.time,
    required this.peopleCount,
    required this.accuracy,
    required this.type,
    required this.onDownload,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs for viewing modes
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              children: [
                _buildTab('Original Image', true),
                _buildTab('Density Map', false),
              ],
            ),
          ),

          // Image placeholder - fixed height instead of Expanded
          Container(
            height: 200.h, // Fixed height
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Placeholder image
                Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 48.sp,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),

                // People count overlay
                Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16.sp,
                          color:
                              type == 'Image'
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          peopleCount.toString(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                type == 'Image'
                                    ? Colors.white
                                    : AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // High density badge if applicable
                if (peopleCount > 500)
                  Positioned(
                    left: 16.w,
                    top: 16.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_outlined,
                            size: 14.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'High Density',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Analysis info
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Location and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$date - $time',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Accuracy info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Accuracy',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${accuracy.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _getAccuracyColor(accuracy),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: Row(
              children: [
                // Download button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDownload,
                    icon: Icon(Icons.download_outlined, size: 16.sp),
                    label: const Text('Download'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Share button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: Icon(Icons.share_outlined, size: 16.sp),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a tab button for the result view modes
  Widget _buildTab(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceColor : AppTheme.backgroundColor,
          border:
              isSelected
                  ? Border(
                    top: BorderSide(color: AppTheme.primaryColor, width: 2.h),
                  )
                  : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  /// Get color based on accuracy value
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 95) {
      return AppTheme.successColor;
    } else if (accuracy >= 90) {
      return AppTheme.primaryColor;
    } else if (accuracy >= 80) {
      return AppTheme.warningColor;
    } else {
      return AppTheme.errorColor;
    }
  }
}
