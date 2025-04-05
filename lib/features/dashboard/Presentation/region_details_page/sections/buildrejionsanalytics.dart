import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors/C.dart';
import '../widgets/buildanalyticscard.dart';

class Buildrejionsanalytics extends StatelessWidget {
  const Buildrejionsanalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: C.primarybackgrond, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          // Row 1
          Buildanalyticscard(
            title: 'Active Alerts',
            value: '3',
            icon: Icons.warning,
          ),
          SizedBox(height: 8.h),
          Buildanalyticscard(
            title: 'Motion Events',
            value: '22',
            icon: Icons.run_circle,
          ),
          SizedBox(height: 8.h),
          // Row 2
          Buildanalyticscard(
            title: 'System Uptime',
            value: '98%',
            icon: Icons.access_time,
          ),
          SizedBox(height: 8.w),
          Buildanalyticscard(
            title: 'Last 24 Hours',
            value: 'Data',
            icon: Icons.timeline,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Region health is optimal")),
                SizedBox(
                  height: 4.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      "Real-time monitoring with motion detection and standard alerts "),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
