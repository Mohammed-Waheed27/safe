import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Container for charts with a title and consistent styling
class ChartContainer extends StatelessWidget {
  /// Title of the chart
  final String title;

  /// Subtitle of the chart (optional)
  final String? subtitle;

  /// Child widget (usually a chart)
  final Widget child;

  /// Actions shown in the top-right corner (optional)
  final List<Widget>? actions;

  /// Constructor
  const ChartContainer({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.actions,
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
              if (actions != null) Row(children: actions!),
            ],
          ),

          SizedBox(height: 16.h),

          // Chart content
          child,
        ],
      ),
    );
  }
}
