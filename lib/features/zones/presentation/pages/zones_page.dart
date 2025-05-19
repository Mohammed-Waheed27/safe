import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';
import '../widgets/zone_card.dart';
import '../widgets/zone_map.dart';

/// Zones page for managing monitoring areas
class ZonesPage extends StatefulWidget {
  const ZonesPage({super.key});

  @override
  State<ZonesPage> createState() => _ZonesPageState();
}

class _ZonesPageState extends State<ZonesPage> {
  bool _showCreateZoneForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Zone Management'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showCreateZoneForm = true;
          });
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page subtitle
              Text(
                'Create and manage monitoring zones for crowd analysis',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 16.h),

              // Zone stats
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _buildStatIndicator(
                      icon: Icons.location_on_outlined,
                      label: 'All Zones',
                      value: '1',
                    ),
                    const Spacer(),
                    _buildStatIndicator(
                      icon: Icons.toggle_on_outlined,
                      label: 'Active',
                      value: '0',
                    ),
                    const Spacer(),
                    _buildStatIndicator(
                      icon: Icons.notifications_active_outlined,
                      label: 'Alerts',
                      value: '1',
                      isAlert: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Create zone form - conditionally displayed
              if (_showCreateZoneForm) _buildCreateZoneForm(),

              // Zone list
              _buildZoneList(),

              SizedBox(height: 80.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 1),
    );
  }

  /// Build a stat indicator with icon, label, and value
  Widget _buildStatIndicator({
    required IconData icon,
    required String label,
    required String value,
    bool isAlert = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: isAlert ? Colors.red : AppTheme.primaryColor,
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build the create zone form
  Widget _buildCreateZoneForm() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New Zone',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),

          // Zone Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zone Name',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'e.g. Main Plaza, Entrance Area',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Number of cameras
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Number of Cameras',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '1',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Maximum capacity slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Maximum Capacity',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '500',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppTheme.primaryColor,
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                  thumbColor: AppTheme.primaryColor,
                  trackHeight: 4.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                ),
                child: Slider(
                  value: 500,
                  min: 10,
                  max: 1000,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Alert threshold slider
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Alert Threshold (80% of max)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '400',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.red,
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                  thumbColor: Colors.red,
                  trackHeight: 4.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                ),
                child: Slider(
                  value: 400,
                  min: 10,
                  max: 1000,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description (Optional)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Add details about this zone...',
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.w),
                ),
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
                maxLines: 4,
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Form buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showCreateZoneForm = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showCreateZoneForm = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Create Zone',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build the zone list
  Widget _buildZoneList() {
    // Mock data
    final zoneData = {
      'id': 'zone1',
      'name': 'Zone zone1',
      'occupancy': 481,
      'maxOccupancy': 500,
      'lastUpdated': '2025-05-03 14:17:01',
      'hasAlert': true,
    };

    return ZoneCard(
      zoneName: zoneData['name'] as String,
      occupancy: zoneData['occupancy'] as int,
      maxOccupancy: zoneData['maxOccupancy'] as int,
      lastUpdated: zoneData['lastUpdated'] as String,
      hasAlert: zoneData['hasAlert'] as bool,
      feedImage: 'assets/images/zone_feed.jpg',
      onEdit: () {
        // Edit zone
      },
      onDelete: () {
        // Delete zone
      },
      onView: () {
        // View zone
      },
    );
  }
}
