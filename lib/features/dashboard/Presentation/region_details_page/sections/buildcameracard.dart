import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors/C.dart';
import '../widgets/buildcamerastate.dart';

class Buildcameracard extends StatelessWidget {
  const Buildcameracard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.primarybackgrond,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for camera image
          Container(
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image:
                    DecorationImage(image: AssetImage("assets/images/1.png"))),
          ),
          SizedBox(height: 12.h),
          Text(
            'North Entrance',
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: C.orange1),
          ),
          Text(
            'Main Building - North Door',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Buildcamerastate(
                icon: Icons.group,
                label: 'Head Count',
                value: '32',
              ),
              Buildcamerastate(
                icon: Icons.percent,
                label: 'Crowd',
                value: '45%',
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Buildcamerastate(
                icon: Icons.warning_amber_outlined,
                label: 'Vehicles',
                value: '2',
              ),
              Buildcamerastate(
                icon: Icons.bar_chart,
                label: 'Objects',
                value: '12',
              ),
            ],
          )
        ],
      ),
    );
  }
}
