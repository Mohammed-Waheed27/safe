import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// A card displaying zone information
class ZoneCard extends StatelessWidget {
  /// Zone name
  final String zoneName;

  /// Current occupancy
  final int occupancy;

  /// Maximum occupancy
  final int maxOccupancy;

  /// Last updated timestamp
  final String lastUpdated;

  /// Whether the zone has an active alert
  final bool hasAlert;

  /// Image path for the feed preview
  final String? feedImage;

  /// Callback when the edit button is pressed
  final VoidCallback onEdit;

  /// Callback when the delete button is pressed
  final VoidCallback onDelete;

  /// Callback when the view button is pressed
  final VoidCallback onView;

  /// Constructor
  const ZoneCard({
    super.key,
    required this.zoneName,
    required this.occupancy,
    required this.maxOccupancy,
    required this.lastUpdated,
    this.hasAlert = false,
    this.feedImage,
    required this.onEdit,
    required this.onDelete,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate occupancy percentage
    final occupancyPercent = (occupancy / maxOccupancy) * 100;

    // Determine color based on occupancy
    final Color progressColor =
        occupancyPercent > 90
            ? Colors.red
            : occupancyPercent > 75
            ? Colors.orange
            : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zone feed image or placeholder
          if (feedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    feedImage!,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 160.h,
                          width: double.infinity,
                          color: Colors.black26,
                          child: Center(
                            child: Icon(
                              Icons.videocam_off_outlined,
                              color: Colors.white.withOpacity(0.5),
                              size: 32.sp,
                            ),
                          ),
                        ),
                  ),
                  if (hasAlert)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Alert',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 160.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.videocam_off_outlined,
                  color: Colors.white.withOpacity(0.5),
                  size: 32.sp,
                ),
              ),
            ),

          // Zone details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Zone name with counter badge
                Row(
                  children: [
                    Text(
                      zoneName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (hasAlert)
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Occupancy bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Occupancy',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '$occupancy / $maxOccupancy',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: progressColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Progress bar
                    Stack(
                      children: [
                        // Background
                        Container(
                          height: 8.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        // Foreground
                        Container(
                          height: 8.h,
                          width:
                              (occupancy / maxOccupancy) *
                              MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Last updated
                Text(
                  'Last updated: $lastUpdated',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),

                SizedBox(height: 16.h),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onView,
                        icon: Icon(Icons.visibility_outlined, size: 18.sp),
                        label: Text('View', style: TextStyle(fontSize: 12.sp)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.backgroundColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.backgroundColor,
                      ),
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
}
