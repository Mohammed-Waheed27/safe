import 'package:flutter/material.dart';
import 'package:miun_live/api_call.dart';
import 'package:miun_live/core/theme/appthme.dart';
import 'package:miun_live/meeting_screen.dart';
import 'package:miun_live/features/live feed/pages/enhanced_meeting_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/models/zone_model.dart';
import '../../../auth/pages/login_page.dart';
import '../zone_selection_page.dart';

class searchActiveFeeds extends StatefulWidget {
  const searchActiveFeeds({super.key});

  @override
  State<searchActiveFeeds> createState() => _searchActiveFeedsState();
}

class _searchActiveFeedsState extends State<searchActiveFeeds> {
  bool isLoading = false;
  List<ZoneModel> userZones = [];
  String status = '';

  @override
  void initState() {
    super.initState();
    _loadUserZones();
  }

  Future<void> _loadUserZones() async {
    setState(() {
      isLoading = true;
      status = '';
    });

    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        _navigateToLogin();
        return;
      }

      // Get user document to get email
      final userDoc = await AuthService.getUserDocument(currentUser.uid);
      if (userDoc == null) {
        throw 'User information not found';
      }

      // Get user's zones
      final zones = await AuthService.getUserZones(userDoc.email);
      setState(() {
        isLoading = false;
        userZones = zones;
        if (zones.isEmpty) {
          status = 'No zones found for your account';
        } else {
          status = 'Found ${zones.length} zone${zones.length == 1 ? '' : 's'}';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        status = 'Error loading zones: ${e.toString()}';
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _logout() async {
    try {
      await AuthService.logout();
      _navigateToLogin();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _joinZone(ZoneModel zone) {
    if (zone.videoSDK.roomId.isEmpty || zone.videoSDK.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This zone is not properly configured for video calls'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedMeetingScreen(
          meetingId: zone.videoSDK.roomId,
          token: zone.videoSDK.token,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Phone Live',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppTheme.textPrimaryColor),
            onPressed: _logout,
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
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.videocam,
                      size: 48.sp,
                      color: AppTheme.primaryColor,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Your Zones',
                      style: TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      status.isNotEmpty ? status : 'Loading your zones...',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Loading or zones list
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      )
                    : userZones.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64.sp,
                                  color: AppTheme.textSecondaryColor,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No zones found',
                                  style: TextStyle(
                                    color: AppTheme.textPrimaryColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Contact support to set up your zones',
                                  style: TextStyle(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                ElevatedButton(
                                  onPressed: _loadUserZones,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Refresh',
                                    style: TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: userZones.length,
                            itemBuilder: (context, index) {
                              final zone = userZones[index];
                              final isConfigured = zone.videoSDK.roomId.isNotEmpty && 
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
                                  onTap: isConfigured ? () => _joinZone(zone) : null,
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
                                          child: zone.image.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(12.r),
                                                  child: Image.network(
                                                    zone.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => 
                                                        Icon(
                                                          Icons.video_camera_back,
                                                          color: AppTheme.primaryColor,
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
                                                      color: isConfigured
                                                          ? Colors.green.withOpacity(0.1)
                                                          : Colors.orange.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(6.r),
                                                    ),
                                                    child: Text(
                                                      isConfigured ? 'Ready' : 'Not Configured',
                                                      style: TextStyle(
                                                        color: isConfigured ? Colors.green : Colors.orange,
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
