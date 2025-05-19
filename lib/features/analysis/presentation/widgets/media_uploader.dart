import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Widget for uploading media (images or videos) for analysis
class MediaUploader extends StatefulWidget {
  /// Callback when media is selected
  final Function(String) onMediaSelected;

  /// Constructor
  const MediaUploader({super.key, required this.onMediaSelected});

  @override
  State<MediaUploader> createState() => _MediaUploaderState();
}

class _MediaUploaderState extends State<MediaUploader> {
  String? _selectedMediaType;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Upload Media',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Upload an image or video for crowd analysis',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),

          SizedBox(height: 32.h),

          // Upload area (drag and drop zone)
          GestureDetector(
            onTap: _selectFile,
            child: Container(
              height: 300.h,
              decoration: BoxDecoration(
                color:
                    _isDragging
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color:
                      _isDragging
                          ? AppTheme.primaryColor
                          : Colors.white.withOpacity(0.2),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48.sp,
                    color:
                        _isDragging
                            ? AppTheme.primaryColor
                            : Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Drag and drop your files here, or browse',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: _isDragging ? AppTheme.primaryColor : Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Supports: JPG, PNG, MP4, MOV (max 500MB)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Media type selector
          Row(
            children: [
              _buildMediaTypeButton('Images', Icons.image_outlined),
              SizedBox(width: 12.w),
              _buildMediaTypeButton('Videos', Icons.videocam_outlined),
              SizedBox(width: 12.w),
              _buildMediaTypeButton('Live Camera', Icons.camera_alt_outlined),
            ],
          ),

          SizedBox(height: 24.h),

          // Cancel button
          Center(
            child: OutlinedButton(
              onPressed: () {
                // Clear selection
                setState(() {
                  _selectedMediaType = null;
                });
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                side: BorderSide(color: Colors.white.withOpacity(0.3)),
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a media type selection button
  Widget _buildMediaTypeButton(String type, IconData icon) {
    final isSelected = _selectedMediaType == type;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMediaType = type;
          });
          widget.onMediaSelected(type);
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color:
                  isSelected
                      ? AppTheme.primaryColor
                      : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color:
                    isSelected
                        ? AppTheme.primaryColor
                        : Colors.white.withOpacity(0.7),
              ),
              SizedBox(height: 8.h),
              Text(
                type,
                style: TextStyle(
                  fontSize: 14.sp,
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
      ),
    );
  }

  /// Show a file selection dialog
  void _selectFile() {
    // In a real app, this would open a file picker
    // For now, simulate file selection
    widget.onMediaSelected('sample_image.jpg');

    setState(() {
      _selectedMediaType = 'Images';
    });

    // Show a simple snackbar to indicate success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'File selected: sample_image.jpg',
          style: TextStyle(fontSize: 14.sp),
        ),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
