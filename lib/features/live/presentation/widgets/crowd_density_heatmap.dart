import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Widget for displaying a crowd density heatmap
class CrowdDensityHeatmap extends StatelessWidget {
  /// Constructor
  const CrowdDensityHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Crowd Density Heatmap',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 16.h),

          // Heatmap visualization
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background
                  Container(color: Colors.black),

                  // Heatmap overlay (simulated with custom painting)
                  CustomPaint(painter: HeatmapPainter(), size: Size.infinite),

                  // Live indicator
                  Positioned(
                    right: 8.w,
                    bottom: 8.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Live',
                            style: TextStyle(
                              fontSize: 10.sp,
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
          ),

          SizedBox(height: 16.h),

          // Camera selector
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.grid_view),
            label: const Text('All Cameras'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.surfaceColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              side: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for heatmap visualization
class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // This is a simplified implementation for demonstration
    // In a real app, you would use actual density data

    // Paint for the heatmap spots
    final redSpot =
        Paint()
          ..shader = RadialGradient(
            colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.0)],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.3, size.height * 0.3),
              radius: size.width * 0.2,
            ),
          );

    final yellowSpot =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.yellow.withOpacity(0.6),
              Colors.yellow.withOpacity(0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.7, size.height * 0.4),
              radius: size.width * 0.15,
            ),
          );

    final greenSpot =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.green.withOpacity(0.5),
              Colors.green.withOpacity(0.0),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.7),
              radius: size.width * 0.18,
            ),
          );

    // Draw spots
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      size.width * 0.2,
      redSpot,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.4),
      size.width * 0.15,
      yellowSpot,
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      size.width * 0.18,
      greenSpot,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
