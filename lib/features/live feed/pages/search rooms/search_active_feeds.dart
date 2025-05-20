import 'package:flutter/material.dart';
import 'package:miun_live/api_call.dart';
import 'package:miun_live/core/theme/appthme.dart';
import 'package:miun_live/meeting_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class searchActiveFeeds extends StatefulWidget {
  const searchActiveFeeds({super.key});

  @override
  State<searchActiveFeeds> createState() => _searchActiveFeedsState();
}

class _searchActiveFeedsState extends State<searchActiveFeeds> {
  bool isLoading = false;
  String? roomId;
  String status = '';

  Future<void> searchForActiveFeed() async {
    setState(() {
      isLoading = true;
      status = '';
      roomId = null;
    });

    try {
      final result = await getActiveRoom();
      setState(() {
        isLoading = false;
        if (result != null) {
          roomId = result;
          status = 'Active feed found!';
        } else {
          status = 'No active feed found';
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        status = 'Error searching for feed: ${e.toString()}';
      });
    }
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 0.8.sw,
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
                      Text(
                        'Welcome to Phone Live',
                        style: TextStyle(
                          color: AppTheme.textPrimaryColor,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Search for active live feeds',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 16.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.h),
                      if (isLoading)
                        CircularProgressIndicator(color: AppTheme.primaryColor)
                      else if (status.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color:
                                roomId != null
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            children: [
                              Text(
                                status,
                                style: TextStyle(
                                  color:
                                      roomId != null
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 18.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (roomId != null) ...[
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MeetingScreen(
                                              meetingId: roomId!,
                                              token: token,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32.w,
                                      vertical: 16.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Join Feed',
                                    style: TextStyle(
                                      color: AppTheme.textPrimaryColor,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      SizedBox(height: 32.h),
                      ElevatedButton(
                        onPressed: searchForActiveFeed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 16.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Search Active Feeds',
                          style: TextStyle(
                            color: AppTheme.textPrimaryColor,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
