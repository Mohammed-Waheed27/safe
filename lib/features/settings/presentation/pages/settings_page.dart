import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_theme.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';
import '../../../../features/dashboard/presentation/widgets/app_sidebar.dart';

/// Settings page for the application
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppTheme.surfaceColor,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                indicatorColor: AppTheme.primaryColor,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Notifications'),
                  Tab(text: 'Security'),
                  Tab(text: 'API Access'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(child: _buildProfileTab()),
                    SingleChildScrollView(child: _buildNotificationsTab()),
                    SingleChildScrollView(child: _buildSecurityTab()),
                    SingleChildScrollView(child: _buildAPIAccessTab()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 7),
    );
  }

  /// Build the profile tab content
  Widget _buildProfileTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(
          title: 'Your Profile',
          subtitle: 'Update your personal information',
          content: Column(
            children: [
              _buildProfileField(
                'Email',
                'tonymop46@gmail.com',
                isDisabled: true,
              ),
              SizedBox(height: 16.h),
              _buildProfileField('Full Name', 'mohammed waheed'),
              SizedBox(height: 16.h),
              _buildProfileField(
                'Phone Number',
                '',
                hint: 'Enter your phone number',
              ),
              SizedBox(height: 16.h),
              _buildProfileField(
                'Company',
                '',
                hint: 'Enter your company name',
              ),
              SizedBox(height: 16.h),
              _buildProfileField('Job Title', '', hint: 'Enter your job title'),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Update profile action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Update profile',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),

        // Logout button
        SettingsSection(
          title: 'Account Actions',
          subtitle: 'Manage your account',
          content: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppRouter.logout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the notifications tab content
  Widget _buildNotificationsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(
          title: 'Notification Preferences',
          subtitle: 'Control when and how you receive notifications',
          content: Column(
            children: [
              SettingsTile(
                title: 'Email Notifications',
                subtitle: 'Receive important updates via email',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              SettingsTile(
                title: 'Push Notifications',
                subtitle: 'Receive alerts on your device',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              SettingsTile(
                title: 'SMS Notifications',
                subtitle: 'Receive alerts via text message',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SettingsSection(
          title: 'Alert Types',
          subtitle: 'Choose which types of alerts to receive',
          content: Column(
            children: [
              SettingsTile(
                title: 'Threshold Alerts',
                subtitle: 'When capacity thresholds are exceeded',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              SettingsTile(
                title: 'Rapid Growth Alerts',
                subtitle: 'When crowd grows rapidly in a short time',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              SettingsTile(
                title: 'System Notifications',
                subtitle: 'Updates about the system status',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the security tab content
  Widget _buildSecurityTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(
          title: 'Password & Authentication',
          subtitle: 'Manage your login credentials',
          content: Column(
            children: [
              SettingsTile(
                title: 'Change Password',
                subtitle: 'Update your current password',
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                ),
                onTap: () {
                  // Change password action
                },
              ),
              SettingsTile(
                title: 'Two-Factor Authentication',
                subtitle: 'Add an extra layer of security',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SettingsSection(
          title: 'Privacy',
          subtitle: 'Control your data and privacy settings',
          content: Column(
            children: [
              SettingsTile(
                title: 'Data Sharing',
                subtitle: 'Control how your data is shared',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              SettingsTile(
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.red.withOpacity(0.7),
                ),
                onTap: () {
                  // Delete account action
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the API access tab content
  Widget _buildAPIAccessTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(
          title: 'API Access Keys',
          subtitle: 'Manage your API credentials',
          content: Column(
            children: [
              SettingsTile(
                title: 'API Key',
                subtitle: '••••••••••••••••',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.visibility_outlined,
                        size: 20.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy_outlined,
                        size: 20.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SettingsTile(
                title: 'Regenerate API Key',
                subtitle: 'Create a new API key and invalidate the current one',
                trailing: Icon(
                  Icons.refresh_outlined,
                  color: Colors.white.withOpacity(0.7),
                ),
                onTap: () {
                  // Regenerate API key action
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SettingsSection(
          title: 'Webhook Configuration',
          subtitle: 'Set up webhooks for real-time updates',
          content: Column(
            children: [
              SettingsTile(
                title: 'Enable Webhooks',
                subtitle: 'Send event data to your endpoints',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              SettingsTile(
                title: 'Configure Endpoints',
                subtitle: 'Manage webhook URLs and event types',
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                ),
                onTap: () {
                  // Configure endpoints action
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SettingsSection(
          title: 'Camera Management',
          subtitle: 'Add and configure cameras in your system',
          content: Column(
            children: [
              SettingsTile(
                title: 'Scan QR Code to Add Camera',
                subtitle: 'Connect a new camera to your system',
                trailing: Icon(
                  Icons.qr_code_scanner_outlined,
                  color: AppTheme.primaryColor,
                  size: 24.sp,
                ),
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.addCamera);
                },
              ),
              SettingsTile(
                title: 'View Connected Cameras',
                subtitle: 'Manage your existing camera connections',
                trailing: Icon(
                  Icons.videocam_outlined,
                  color: Colors.white.withOpacity(0.7),
                ),
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.liveMonitoring);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a profile information field
  Widget _buildProfileField(
    String label,
    String value, {
    bool isDisabled = false,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: value,
          enabled: !isDisabled,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          style: TextStyle(
            fontSize: 14.sp,
            color: isDisabled ? Colors.white.withOpacity(0.5) : Colors.white,
          ),
        ),
        if (isDisabled)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              'Your email address cannot be changed',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
      ],
    );
  }
}
