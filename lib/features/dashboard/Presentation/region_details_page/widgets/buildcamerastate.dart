import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors/C.dart';

class Buildcamerastate extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  Buildcamerastate({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      width: 180.w,
      height: 50.h,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4), color: C.grey1),
      child: Row(
        children: [
          Icon(icon, color: C.grey2, size: 20),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: C.grey2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
