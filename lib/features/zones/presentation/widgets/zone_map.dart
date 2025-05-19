import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// A widget that displays a visual map of zones
class ZoneMap extends StatelessWidget {
  /// Currently selected zone ID
  final String? selectedZoneId;

  /// List of zones data
  final List<Map<String, dynamic>> zones;

  /// Callback when a zone is selected on the map
  final Function(String) onZoneSelected;

  /// Constructor
  const ZoneMap({
    super.key,
    required this.selectedZoneId,
    required this.zones,
    required this.onZoneSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base map
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Container(
                    color: Colors.black,
                    child: CustomPaint(
                      painter: ZoneMapPainter(
                        zones: zones,
                        selectedZoneId: selectedZoneId,
                      ),
                      child: GestureDetector(
                        onTapDown: (details) {
                          // In a real app, this would check if a zone was tapped
                          // based on the coordinates and select it
                          _handleMapTap(context, details.localPosition);
                        },
                      ),
                    ),
                  ),
                ),

                // Map labels
                ..._buildZoneLabels(),

                // Map controls
                Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: Column(
                    children: [
                      _buildMapButton(
                        icon: Icons.add,
                        onPressed: () {
                          // Zoom in
                        },
                      ),
                      SizedBox(height: 8.h),
                      _buildMapButton(
                        icon: Icons.remove,
                        onPressed: () {
                          // Zoom out
                        },
                      ),
                      SizedBox(height: 8.h),
                      _buildMapButton(
                        icon: Icons.fullscreen,
                        onPressed: () {
                          // Full screen view
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Normal', AppTheme.successColor),
                _buildLegendItem('Warning', AppTheme.warningColor),
                _buildLegendItem('Alert', AppTheme.errorColor),
                _buildLegendItem('Selected', AppTheme.primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a list of zone labels to overlay on the map
  List<Widget> _buildZoneLabels() {
    final List<Widget> labels = [];

    // Sample zone label positions for demonstration
    // In a real app, these would be calculated based on actual zone positions
    final positions = [
      Offset(0.3, 0.3), // Main Plaza
      Offset(0.7, 0.6), // Food Court
      Offset(0.15, 0.7), // Entrance A
      Offset(0.85, 0.7), // Entrance B
      Offset(0.5, 0.2), // VIP Area
    ];

    for (int i = 0; i < zones.length && i < positions.length; i++) {
      final zone = zones[i];
      final position = positions[i];

      labels.add(
        Positioned(
          left: position.dx * 100.w.clamp(50, 1000),
          top: position.dy * 100.h.clamp(50, 500),
          child: GestureDetector(
            onTap: () {
              onZoneSelected(zone['id'] as String);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color:
                    zone['id'] == selectedZoneId
                        ? AppTheme.primaryColor
                        : _getZoneColor(zone['status'] as String),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                zone['name'] as String,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return labels;
  }

  /// Build a map control button
  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18.sp, color: Colors.white),
        padding: EdgeInsets.all(8.w),
        constraints: const BoxConstraints(),
      ),
    );
  }

  /// Build a legend item with color and label
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  /// Handle tap on the map
  void _handleMapTap(BuildContext context, Offset localPosition) {
    // In a real app, you would determine which zone was tapped
    // based on the coordinates

    // For demo, just select a random zone
    if (zones.isNotEmpty) {
      final randomIndex = DateTime.now().millisecond % zones.length;
      onZoneSelected(zones[randomIndex]['id'] as String);
    }
  }

  /// Get color based on zone status
  Color _getZoneColor(String status) {
    switch (status.toLowerCase()) {
      case 'warning':
        return AppTheme.warningColor;
      case 'alert':
        return AppTheme.errorColor;
      case 'normal':
      default:
        return AppTheme.successColor;
    }
  }
}

/// Custom painter for drawing the zone map
class ZoneMapPainter extends CustomPainter {
  /// List of zones
  final List<Map<String, dynamic>> zones;

  /// Currently selected zone ID
  final String? selectedZoneId;

  /// Constructor
  ZoneMapPainter({required this.zones, required this.selectedZoneId});

  @override
  void paint(Canvas canvas, Size size) {
    // For demonstration, just draw a simple floor plan
    // In a real app, this would be a more complex rendering based on actual venue data

    // Draw background
    final backgroundPaint = Paint()..color = Colors.grey[900]!;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Draw floor lines
    final linePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1;

    // Horizontal lines
    for (int i = 1; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height / 10 * i),
        Offset(size.width, size.height / 10 * i),
        linePaint,
      );
    }

    // Vertical lines
    for (int i = 1; i < 10; i++) {
      canvas.drawLine(
        Offset(size.width / 10 * i, 0),
        Offset(size.width / 10 * i, size.height),
        linePaint,
      );
    }

    // Draw zone shapes
    _drawZones(canvas, size);
  }

  /// Draw zone shapes on the map
  void _drawZones(Canvas canvas, Size size) {
    // Sample zone positions and sizes for demonstration
    // In a real app, these would come from actual zone data
    final zoneShapes = [
      {
        'id': '1', // Main Plaza
        'rect': Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.2,
          size.width * 0.3,
          size.height * 0.3,
        ),
      },
      {
        'id': '2', // Food Court
        'rect': Rect.fromLTWH(
          size.width * 0.6,
          size.height * 0.5,
          size.width * 0.2,
          size.height * 0.2,
        ),
      },
      {
        'id': '3', // Entrance A
        'rect': Rect.fromLTWH(
          size.width * 0.1,
          size.height * 0.65,
          size.width * 0.1,
          size.height * 0.1,
        ),
      },
      {
        'id': '4', // Entrance B
        'rect': Rect.fromLTWH(
          size.width * 0.8,
          size.height * 0.65,
          size.width * 0.1,
          size.height * 0.1,
        ),
      },
      {
        'id': '5', // VIP Area
        'rect': Rect.fromLTWH(
          size.width * 0.4,
          size.height * 0.1,
          size.width * 0.2,
          size.height * 0.2,
        ),
      },
    ];

    for (final shape in zoneShapes) {
      final zoneId = shape['id'] as String;
      final rect = shape['rect'] as Rect;

      // Find corresponding zone data
      final zoneData = zones.firstWhere(
        (zone) => zone['id'] == zoneId,
        orElse:
            () => {
              'id': zoneId,
              'status': 'normal',
              'currentCount': 0,
              'capacity': 100,
            },
      );

      // Determine color based on status and selection
      Color zoneColor;
      if (zoneId == selectedZoneId) {
        zoneColor = AppTheme.primaryColor.withOpacity(0.3);
      } else {
        final status = zoneData['status'] as String;
        switch (status.toLowerCase()) {
          case 'warning':
            zoneColor = AppTheme.warningColor.withOpacity(0.3);
            break;
          case 'alert':
            zoneColor = AppTheme.errorColor.withOpacity(0.3);
            break;
          case 'normal':
          default:
            zoneColor = AppTheme.successColor.withOpacity(0.3);
            break;
        }
      }

      // Draw zone
      final zonePaint =
          Paint()
            ..color = zoneColor
            ..style = PaintingStyle.fill;

      final strokePaint =
          Paint()
            ..color =
                zoneId == selectedZoneId
                    ? AppTheme.primaryColor
                    : zoneColor.withOpacity(0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = zoneId == selectedZoneId ? 2 : 1;

      // Draw filled shape
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        zonePaint,
      );

      // Draw stroke
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ZoneMapPainter oldDelegate) {
    return oldDelegate.selectedZoneId != selectedZoneId ||
        oldDelegate.zones != zones;
  }
}
