import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';
import '../widgets/media_uploader.dart';
import '../widgets/analysis_options.dart';

/// Analysis page for uploading and configuring media for crowd analysis
class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('New Analysis'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Reset',
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
              // Subtitle
              Text(
                'Upload and analyze images or videos',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 24.h),

              // Media upload section
              MediaUploader(
                onMediaSelected: (media) {
                  // Handle the selected media
                  debugPrint('Media selected: $media');
                },
              ),

              SizedBox(height: 16.h),

              // Analysis options section
              AnalysisOptions(
                onStartAnalysis: () {
                  // Start the analysis process
                  debugPrint('Starting analysis...');
                  _showAnalysisInProgressDialog(context);
                },
              ),

              SizedBox(height: 80.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 3),
    );
  }

  /// Show an analysis in progress dialog
  void _showAnalysisInProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppTheme.surfaceColor,
            title: Text(
              'Analysis in Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 3.h,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Processing your image/video. This may take a few moments...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16.sp,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Analysis time depends on size and resolution',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // For demo purposes, simulate result
                  _simulateAnalysisComplete(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Simulate analysis completion (for demo purposes)
  void _simulateAnalysisComplete(BuildContext context) {
    // In a real app, this would be part of a BLoC or ViewModel
    Future.delayed(const Duration(seconds: 1), () {
      // Navigate to results screen with Navigator instead of Go Router
      // Navigator.pushNamed(context, '/results/123');

      // For now, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Analysis complete! 352 people detected.',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}
