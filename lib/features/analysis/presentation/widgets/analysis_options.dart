import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';

/// Widget for configuring analysis options
class AnalysisOptions extends StatefulWidget {
  /// Callback when the analysis should start
  final VoidCallback onStartAnalysis;

  /// Constructor
  const AnalysisOptions({super.key, required this.onStartAnalysis});

  @override
  State<AnalysisOptions> createState() => _AnalysisOptionsState();
}

class _AnalysisOptionsState extends State<AnalysisOptions> {
  bool _generateDensityMap = true;
  bool _visualizeCount = true;
  bool _setCrowdAlert = false;
  double _alertThreshold = 500;
  String _selectedAiModel = 'CLIP-EBC (VIT-B/16)';
  String _selectedProcessingSpeed = 'Balanced';

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
            'Analysis Options',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Configure your crowd analysis parameters',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),

          SizedBox(height: 32.h),

          // AI Model dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Model',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              _buildDropdownField(
                value: _selectedAiModel,
                items: [
                  'CLIP-EBC (VIT-B/16)',
                  'YOLO-CSP',
                  'Faster RCNN',
                  'CrowdNet v2',
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedAiModel = value;
                    });
                  }
                },
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Generate Density Map option
          _buildSwitchOption(
            title: 'Generate Density Map',
            description: 'Shows the distribution of people in the image',
            value: _generateDensityMap,
            onChanged: (value) {
              setState(() {
                _generateDensityMap = value;
              });
            },
          ),

          SizedBox(height: 16.h),

          // Visualize Count option
          _buildSwitchOption(
            title: 'Visualize Count',
            description: 'Overlay the count on the output image',
            value: _visualizeCount,
            onChanged: (value) {
              setState(() {
                _visualizeCount = value;
              });
            },
          ),

          SizedBox(height: 16.h),

          // Set Crowd Alert option
          _buildSwitchOption(
            title: 'Set Crowd Alert',
            description: 'Get notified when the crowd exceeds a threshold',
            value: _setCrowdAlert,
            onChanged: (value) {
              setState(() {
                _setCrowdAlert = value;
              });
            },
          ),

          // Alert Threshold slider (only visible when alerts are enabled)
          if (_setCrowdAlert) ...[
            SizedBox(height: 16.h),
            Text(
              'Alert Threshold',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  '10',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _alertThreshold,
                    min: 10,
                    max: 2000,
                    divisions: 199,
                    label: _alertThreshold.toInt().toString(),
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: Colors.white.withOpacity(0.2),
                    onChanged: (value) {
                      setState(() {
                        _alertThreshold = value;
                      });
                    },
                  ),
                ),
                Text(
                  '2000',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 24.h),

          // Processing Speed dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Processing Speed',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              _buildDropdownField(
                value: _selectedProcessingSpeed,
                items: ['Fastest', 'Balanced', 'High Accuracy'],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedProcessingSpeed = value;
                    });
                  }
                },
              ),
              SizedBox(height: 4.h),
              Text(
                'Balance between speed and accuracy',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Reset and Start buttons
          Row(
            children: [
              OutlinedButton(
                onPressed: _resetOptions,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset to Defaults'),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onStartAnalysis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: const Text('Start Analysis'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a dropdown field with consistent styling
  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppTheme.backgroundColor,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          isExpanded: true,
          onChanged: onChanged,
          items:
              items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
        ),
      ),
    );
  }

  /// Build a switch option with title and description
  Widget _buildSwitchOption({
    required String title,
    required String description,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
          inactiveTrackColor: Colors.white.withOpacity(0.1),
        ),
      ],
    );
  }

  /// Reset all options to default values
  void _resetOptions() {
    setState(() {
      _generateDensityMap = true;
      _visualizeCount = true;
      _setCrowdAlert = false;
      _alertThreshold = 500;
      _selectedAiModel = 'CLIP-EBC (VIT-B/16)';
      _selectedProcessingSpeed = 'Balanced';
    });
  }
}
