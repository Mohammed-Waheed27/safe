import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// A dropdown filter widget for filtering or sorting results
class ResultFilter extends StatelessWidget {
  /// Label to display as the dropdown title
  final String label;

  /// Currently selected value
  final String value;

  /// Available options
  final List<String> options;

  /// Callback when selection changes
  final Function(String?) onChanged;

  /// Constructor
  const ResultFilter({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withOpacity(0.7),
            size: 20.sp,
          ),
          isExpanded: true,
          dropdownColor: AppTheme.surfaceColor,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
          onChanged: onChanged,
          items:
              options.map<DropdownMenuItem<String>>((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
