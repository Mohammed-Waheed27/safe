import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Widget for selecting a time period (e.g., daily, weekly, monthly)
class PeriodSelector extends StatelessWidget {
  /// List of available options
  final List<String> options;

  /// Currently selected option
  final String selectedOption;

  /// Callback when an option is selected
  final Function(String) onOptionSelected;

  /// Constructor
  const PeriodSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected = option == selectedOption;

          return InkWell(
            onTap: () => onOptionSelected(option),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
