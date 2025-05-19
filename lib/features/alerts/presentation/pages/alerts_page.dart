import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_stat_card.dart';

/// Alerts page for managing and viewing alerts and notifications
class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _tabTitles = ['Alert History', 'Alert Settings'];
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Alerts & Notifications'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page subtitle
              Text(
                'Manage your alert preferences and view history',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 16.h),

              // Tab selector
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: List.generate(
                    _tabTitles.length,
                    (index) => Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color:
                                _selectedTabIndex == index
                                    ? AppTheme.primaryColor.withOpacity(0.1)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border:
                                _selectedTabIndex == index
                                    ? Border(
                                      bottom: BorderSide(
                                        color: AppTheme.primaryColor,
                                        width: 2.h,
                                      ),
                                    )
                                    : null,
                          ),
                          child: Text(
                            _tabTitles[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight:
                                  _selectedTabIndex == index
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                              color:
                                  _selectedTabIndex == index
                                      ? AppTheme.primaryColor
                                      : Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Tab content
              _selectedTabIndex == 0
                  ? _buildAlertHistoryTab()
                  : _buildAlertSettingsTab(),

              SizedBox(height: 80.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 6),
    );
  }

  /// Build the alert history tab content
  Widget _buildAlertHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alert stats - mobile layout in a column
        AlertStatCard(
          title: 'Today\'s Alerts',
          count: 3,
          subtitle: '1 still active',
        ),

        SizedBox(height: 12.h),

        AlertStatCard(
          title: 'This Week',
          count: 12,
          subtitle: '+3 from last week',
        ),

        SizedBox(height: 12.h),

        AlertStatCard(
          title: 'Alert Types',
          count: 5,
          subtitle: '3 currently enabled',
        ),

        SizedBox(height: 16.h),

        // Recent alerts section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Alerts',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Clear All',
                style: TextStyle(fontSize: 14.sp, color: AppTheme.primaryColor),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        // Alert cards - vertical list
        AlertCard(
          title: 'Main Square exceeded capacity threshold',
          time: 'Apr 26, 2:30 PM',
          value: '576',
          threshold: '500',
          isActive: true,
          type: AlertType.capacity,
          onDismiss: () {
            // Handle dismiss
          },
        ),

        SizedBox(height: 12.h),

        AlertCard(
          title: 'Rapid crowd growth at Food Court',
          time: 'Apr 26, 12:15 PM',
          value: '28% in 3 minutes',
          threshold: '25% in 5 min',
          isActive: false,
          type: AlertType.growth,
          onDismiss: () {
            // Handle dismiss
          },
        ),

        SizedBox(height: 12.h),

        AlertCard(
          title: 'Entrance A zone density threshold exceeded',
          time: 'Apr 25, 5:45 PM',
          value: '215',
          threshold: '200',
          isActive: false,
          type: AlertType.density,
          onDismiss: () {
            // Handle dismiss
          },
        ),

        SizedBox(height: 12.h),

        AlertCard(
          title: 'Food Court approaching capacity',
          time: 'Apr 25, 12:20 PM',
          value: '294',
          threshold: '300',
          isActive: false,
          type: AlertType.approaching,
          onDismiss: () {
            // Handle dismiss
          },
        ),

        SizedBox(height: 12.h),

        AlertCard(
          title: 'Entrance B flow rate exceeded threshold',
          time: 'Apr 24, 9:10 AM',
          value: '45 per min',
          threshold: '40 per min',
          isActive: false,
          type: AlertType.flow,
          onDismiss: () {
            // Handle dismiss
          },
        ),
      ],
    );
  }

  /// Build the alert settings tab content
  Widget _buildAlertSettingsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instructions
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 24.sp,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alert Settings',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Configure which alerts you want to receive and their thresholds. Alert settings can also be configured per zone in the Zone Management section.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Settings sections
        _buildSettingSection(
          title: 'Notification Channels',
          children: [
            _buildToggleSetting('In-app Notifications', true, (value) {}),
            SizedBox(height: 12.h),
            _buildToggleSetting('Email Notifications', false, (value) {}),
            SizedBox(height: 12.h),
            _buildToggleSetting(
              'SMS Notifications',
              false,
              (value) {},
              isPremium: true,
            ),
          ],
        ),

        SizedBox(height: 16.h),

        _buildSettingSection(
          title: 'Alert Types',
          children: [
            _buildToggleSetting('Capacity Threshold Alerts', true, (value) {}),
            SizedBox(height: 12.h),
            _buildToggleSetting('Rapid Growth Alerts', true, (value) {}),
            SizedBox(height: 12.h),
            _buildToggleSetting('Density Alerts', true, (value) {}),
            SizedBox(height: 12.h),
            _buildToggleSetting('Flow Rate Alerts', false, (value) {}),
          ],
        ),

        SizedBox(height: 24.h),

        // Save button
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Save settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Alert settings saved successfully',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: const Text('Save Settings'),
          ),
        ),
      ],
    );
  }

  /// Build a setting section with title and children
  Widget _buildSettingSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  /// Build a toggle setting with title and description
  Widget _buildToggleSetting(
    String title,
    bool value,
    Function(bool) onChanged, {
    String? description,
    bool isPremium = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  if (isPremium) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'PREMIUM',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (description != null) ...[
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: isPremium ? null : onChanged,
          activeColor: AppTheme.primaryColor,
          inactiveTrackColor: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }
}
