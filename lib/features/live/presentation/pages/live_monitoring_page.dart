import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';
import '../../../../core/config/app_router.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';
import '../widgets/camera_feed.dart';
import '../widgets/crowd_density_heatmap.dart';
import '../widgets/status_widget.dart';

/// Live monitoring page for the Ru'yaAI application
class LiveMonitoringPage extends StatefulWidget {
  const LiveMonitoringPage({super.key});

  @override
  State<LiveMonitoringPage> createState() => _LiveMonitoringPageState();
}

class _LiveMonitoringPageState extends State<LiveMonitoringPage> {
  String _selectedZone = 'Main Plaza';
  String _selectedLayout = '2×2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Live Monitoring'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            tooltip: 'Configure',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addCamera);
        },
        backgroundColor: AppTheme.primaryColor,
        tooltip: 'Add Camera',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone selector and layout options
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real-time crowd counting from connected cameras',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Zone selector dropdown
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedZone,
                        dropdownColor: AppTheme.surfaceColor,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        isExpanded: true,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedZone = value;
                            });
                          }
                        },
                        items:
                            [
                                  'Main Plaza',
                                  'Food Court',
                                  'Concert Venue',
                                  'South Entrance',
                                ]
                                .map(
                                  (zone) => DropdownMenuItem(
                                    value: zone,
                                    child: Text(zone),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Layout options row
                  Row(
                    children: [
                      _buildLayoutButton('2×2', Icons.grid_view),
                      SizedBox(width: 8.w),
                      _buildLayoutButton('3×3', Icons.apps),
                      SizedBox(width: 8.w),
                      _buildLayoutButton('Single', Icons.fullscreen),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.fit_screen),
                        tooltip: 'Fullscreen',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'Volume',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Camera feeds and status - make it scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child:
                      _selectedLayout == '2×2'
                          ? _buildGridLayout2x2()
                          : _selectedLayout == '3×3'
                          ? _buildGridLayout3x3()
                          : _buildSingleLayout(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 2),
    );
  }

  Widget _buildLayoutButton(String layout, IconData icon) {
    final isSelected = _selectedLayout == layout;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLayout = layout;
        });
      },
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              layout,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridLayout2x2() {
    double cameraHeight =
        MediaQuery.of(context).size.height * 0.2; // Responsive height

    return Column(
      children: [
        // First row of cameras
        SizedBox(
          height: cameraHeight,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const CameraFeed(
                    cameraName: 'Entrance',
                    peopleCount: 34,
                    isOnline: false,
                    hasAlert: true,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const CameraFeed(
                    cameraName: 'Center 2',
                    peopleCount: 31,
                    isOnline: true,
                    hasAlert: false,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Second row of cameras
        SizedBox(
          height: cameraHeight,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const CameraFeed(
                    cameraName: 'North Corner',
                    peopleCount: 28,
                    isOnline: true,
                    hasAlert: false,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: const CameraFeed(
                    cameraName: 'South Corner',
                    peopleCount: 16,
                    isOnline: false,
                    hasAlert: true,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Status widget
        SizedBox(height: 12.h),
        StatusWidget(
          zoneName: _selectedZone,
          peopleCount: 98,
          currentOccupancy: 92,
          alertThreshold: 70,
          cameraCount: 4,
          status: 'Normal',
          timestamp: DateTime.now(),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildGridLayout3x3() {
    return Column(
      children: [
        // Grid of cameras - using aspect ratio for responsive sizing
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            // Vary the properties for different cameras
            final names = [
              'Entrance 1',
              'Center 2',
              'North Corner',
              'South Corner',
              'East Entrance',
              'West Entrance',
              'Main Hall',
              'Food Court',
              'Parking Lot',
            ];
            final counts = [34, 31, 28, 16, 22, 19, 43, 37, 12];
            return CameraFeed(
              cameraName: names[index],
              peopleCount: counts[index],
              isOnline: index % 3 != 0,
              hasAlert: index % 4 == 0,
            );
          },
        ),

        // Status widget
        SizedBox(height: 12.h),
        StatusWidget(
          zoneName: _selectedZone,
          peopleCount: 242,
          currentOccupancy: 85,
          alertThreshold: 70,
          cameraCount: 9,
          status: 'Normal',
          timestamp: DateTime.now(),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSingleLayout() {
    double cameraHeight =
        MediaQuery.of(context).size.height * 0.4; // Responsive height

    return Column(
      children: [
        // Single camera view
        SizedBox(
          height: cameraHeight,
          child: const CameraFeed(
            cameraName: 'Main Plaza - Center View',
            peopleCount: 98,
            isOnline: true,
            hasAlert: false,
            isFullscreen: true,
          ),
        ),

        // Status widget
        SizedBox(height: 12.h),
        StatusWidget(
          zoneName: _selectedZone,
          peopleCount: 98,
          currentOccupancy: 92,
          alertThreshold: 70,
          cameraCount: 1,
          status: 'Normal',
          timestamp: DateTime.now(),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
