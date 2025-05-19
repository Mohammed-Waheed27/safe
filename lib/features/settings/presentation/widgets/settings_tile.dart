import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A tile widget for individual settings
class SettingsTile extends StatelessWidget {
  /// Title of the setting
  final String title;

  /// Optional subtitle or description
  final String? subtitle;

  /// Optional leading icon
  final IconData? leading;

  /// Optional trailing widget or icon
  final dynamic trailing;

  /// Callback when the tile is tapped
  final VoidCallback? onTap;

  /// Constructor
  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Leading icon
            if (leading != null) ...[
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    leading,
                    size: 18.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget or icon
            if (trailing != null) ...[SizedBox(width: 16.w), _buildTrailing()],
          ],
        ),
      ),
    );
  }

  /// Build the trailing widget based on its type
  Widget _buildTrailing() {
    if (trailing is IconData) {
      return Icon(
        trailing as IconData,
        size: 16.sp,
        color: Colors.white.withOpacity(0.7),
      );
    } else if (trailing is Widget) {
      return trailing as Widget;
    } else {
      return const SizedBox.shrink();
    }
  }
}
