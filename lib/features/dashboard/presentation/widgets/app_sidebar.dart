import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../live/presentation/pages/live_monitoring_page.dart';
import '../../../analysis/presentation/pages/analysis_page.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../zones/presentation/pages/zones_page.dart';
import '../../../results/presentation/pages/results_page.dart';
import '../../../alerts/presentation/pages/alerts_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

/// Navigation widget for the application
/// Uses bottom navigation on mobile and drawer for additional options
class AppSidebar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Constructor
  const AppSidebar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // Show drawer on mobile instead of sidebar
    return _buildMobileNavigation(context);
  }

  /// Build mobile navigation with drawer and bottom navbar
  Widget _buildMobileNavigation(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Bottom navigation bar for main sections
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: 'Dashboard',
                    isSelected: currentIndex == 0,
                    onTap: () => _navigateTo(context, const DashboardPage()),
                  ),
                  _buildBottomNavItem(
                    context,
                    icon: Icons.videocam_outlined,
                    title: 'Live',
                    isSelected: currentIndex == 2,
                    onTap:
                        () => _navigateTo(context, const LiveMonitoringPage()),
                  ),
                  _buildBottomNavItem(
                    context,
                    icon: Icons.add_chart,
                    title: 'Analyze',
                    isSelected: currentIndex == 3,
                    onTap: () => _navigateTo(context, const AnalysisPage()),
                  ),
                  _buildBottomNavItem(
                    context,
                    icon: Icons.analytics_outlined,
                    title: 'Analytics',
                    isSelected: currentIndex == 5,
                    onTap: () => _navigateTo(context, const AnalyticsPage()),
                  ),
                  _buildBottomNavItem(
                    context,
                    icon: Icons.menu,
                    title: 'More',
                    isSelected: false,
                    onTap: () => _openDrawer(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Navigate to the given page with Navigator
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Build a bottom navigation item
  Widget _buildBottomNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color:
                  isSelected
                      ? AppTheme.primaryColor
                      : Colors.white.withOpacity(0.7),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color:
                    isSelected
                        ? AppTheme.primaryColor
                        : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Open the drawer with additional navigation options
  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      builder: (context) => _buildMoreOptionsSheet(context),
    );
  }

  /// Build more options sheet (replacement for drawer)
  Widget _buildMoreOptionsSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with app title
          Row(
            children: [
              Icon(Icons.bar_chart, color: AppTheme.primaryColor, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                'Ru\'yaAI',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Additional navigation options
          _buildDrawerItem(
            context,
            icon: Icons.location_on_outlined,
            title: 'Zones',
            isSelected: currentIndex == 1,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const ZonesPage());
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.show_chart,
            title: 'Results',
            isSelected: currentIndex == 4,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const ResultsPage());
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.notifications_outlined,
            title: 'Alerts',
            isSelected: currentIndex == 6,
            badge: true,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const AlertsPage());
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            isSelected: currentIndex == 7,
            onTap: () {
              Navigator.pop(context);
              _navigateTo(context, const SettingsPage());
            },
          ),

          SizedBox(height: 8.h),
          Divider(color: Colors.white.withOpacity(0.1)),
          SizedBox(height: 8.h),

          // Quick access zones
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Access Zones',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),

          _buildQuickAccessItem(context, title: 'Main Plaza', onTap: () {}),
          _buildQuickAccessItem(context, title: 'Food Court', onTap: () {}),
          _buildQuickAccessItem(context, title: 'Concert Venue', onTap: () {}),
          _buildQuickAccessItem(context, title: 'South Entrance', onTap: () {}),

          SizedBox(height: 16.h),

          // Light mode toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.light_mode_outlined,
                size: 16.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              SizedBox(width: 8.w),
              Text(
                'Light Mode',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(width: 8.w),
              Switch(
                value: false,
                onChanged: (value) {},
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  /// Build a drawer item
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    bool badge = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isSelected ? AppTheme.primaryColor : Colors.white.withOpacity(0.7),
        size: 20.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          fontSize: 16.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing:
          badge
              ? Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              )
              : null,
      onTap: onTap,
    );
  }

  /// Build a quick access zone item
  Widget _buildQuickAccessItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        size: 10.sp,
        color: Colors.white.withOpacity(0.5),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14.sp, color: Colors.white.withOpacity(0.7)),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
    );
  }
}
