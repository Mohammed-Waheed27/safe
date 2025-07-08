import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/appthme.dart';
import '../../../core/models/zone_model.dart';
import '../../../core/services/auth_service.dart';
import 'enhanced_meeting_screen.dart';
import '../../auth/pages/login_page.dart';

class ZoneSelectionPage extends StatelessWidget {
  final List<ZoneModel> zones;

  const ZoneSelectionPage({super.key, required this.zones});

  void _joinZone(BuildContext context, ZoneModel zone) {
    if (zone.videoSDK.roomId.isEmpty || zone.videoSDK.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'This zone is not properly configured for video calls',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => EnhancedMeetingScreen(
              meetingId: zone.videoSDK.roomId,
              token: zone.videoSDK.token,
            ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await AuthService.logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Select Zone',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppTheme.textPrimaryColor),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.video_settings,
                      size: 32.sp,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Choose a Zone to Join',
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'You have ${zones.length} zones available',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Zones list
              Expanded(
                child: ListView.builder(
                  itemCount: zones.length,
                  itemBuilder: (context, index) {
                    final zone = zones[index];
                    final isConfigured =
                        zone.videoSDK.roomId.isNotEmpty &&
                        zone.videoSDK.token.isNotEmpty;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          width: 1.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap:
                            isConfigured
                                ? () => _joinZone(context, zone)
                                : null,
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            children: [
                              // Zone image/icon
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child:
                                    zone.image.isNotEmpty
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                          child: Image.network(
                                            zone.image,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                                      Icons.video_camera_back,
                                                      color:
                                                          AppTheme.primaryColor,
                                                      size: 30.sp,
                                                    ),
                                          ),
                                        )
                                        : Icon(
                                          Icons.video_camera_back,
                                          color: AppTheme.primaryColor,
                                          size: 30.sp,
                                        ),
                              ),
                              SizedBox(width: 16.w),

                              // Zone info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      zone.name,
                                      style: TextStyle(
                                        color: AppTheme.textPrimaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    if (zone.description.isNotEmpty)
                                      Text(
                                        zone.description,
                                        style: TextStyle(
                                          color: AppTheme.textSecondaryColor,
                                          fontSize: 14.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    SizedBox(height: 8.h),

                                    // Zone status
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isConfigured
                                                    ? Colors.green.withOpacity(
                                                      0.1,
                                                    )
                                                    : Colors.orange.withOpacity(
                                                      0.1,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              6.r,
                                            ),
                                          ),
                                          child: Text(
                                            isConfigured
                                                ? 'Ready'
                                                : 'Not Configured',
                                            style: TextStyle(
                                              color:
                                                  isConfigured
                                                      ? Colors.green
                                                      : Colors.orange,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '${zone.cameras} camera${zone.cameras != 1 ? 's' : ''}',
                                          style: TextStyle(
                                            color: AppTheme.textSecondaryColor,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Join button/indicator
                              if (isConfigured)
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: AppTheme.textPrimaryColor,
                                    size: 20.sp,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.warning,
                                  color: Colors.orange,
                                  size: 20.sp,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
