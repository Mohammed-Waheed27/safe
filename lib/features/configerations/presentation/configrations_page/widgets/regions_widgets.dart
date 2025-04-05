import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors/C.dart';

class RegionCard extends StatelessWidget {
  final String name;
  final String createdDate;
  final String description;
  final String analysisType;
  final int camerasCount;

  const RegionCard({
    required this.name,
    required this.createdDate,
    required this.description,
    required this.analysisType,
    required this.camerasCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: C.primarybackgrond,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.camera_alt_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text('$camerasCount Cameras'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Created $createdDate',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 100.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4), color: C.orange2),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.analytics_outlined,
                            color: Colors.deepOrange,
                            size: 20,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            analysisType,
                            style: const TextStyle(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        height: 30,
                        decoration: BoxDecoration(
                          color: C.orange3,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Advanced Motion Detection with AI-Powered Analytics',
                          style: TextStyle(
                            color: C.black,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Implement settings functionality
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
