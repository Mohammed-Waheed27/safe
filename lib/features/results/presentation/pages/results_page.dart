import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';
import '../widgets/analysis_result_card.dart';
import '../widgets/result_filter.dart';
import '../widgets/search_field.dart';

/// Results page for viewing analysis results
class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  String _searchQuery = '';
  String _selectedFilter = 'All types';
  String _selectedSort = 'Newest first';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Analysis Results'),
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
              // Subtitle
              Text(
                'View and manage your analysis results',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 16.h),

              // Search field
              SearchField(
                hintText: 'Search results...',
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),

              SizedBox(height: 16.h),

              // Filters row
              Row(
                children: [
                  // Type filter
                  Expanded(
                    child: ResultFilter(
                      label: 'All types',
                      value: _selectedFilter,
                      options: const ['All types', 'Image', 'Video', 'Live'],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedFilter = value;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Sort order
                  Expanded(
                    child: ResultFilter(
                      label: 'Newest first',
                      value: _selectedSort,
                      options: const [
                        'Newest first',
                        'Oldest first',
                        'Highest count',
                        'Lowest count',
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSort = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Results grid - changed to a list for mobile
              _buildResultsList(),

              SizedBox(height: 80.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 4),
    );
  }

  /// Build a list of analysis results
  Widget _buildResultsList() {
    // Mock data for demonstration
    final results = [
      {
        'id': '1',
        'location': 'Main Square',
        'date': 'Apr 24, 2025',
        'time': '11:45',
        'peopleCount': 352,
        'accuracy': 94.2,
        'type': 'Image',
      },
      {
        'id': '2',
        'location': 'Concert Venue',
        'date': 'Apr 22, 2025',
        'time': '08:30',
        'peopleCount': 1254,
        'accuracy': 92.1,
        'type': 'Image',
      },
      {
        'id': '3',
        'location': 'City Park',
        'date': 'Apr 22, 2025',
        'time': '14:15',
        'peopleCount': 512,
        'accuracy': 95.3,
        'type': 'Video',
      },
      {
        'id': '4',
        'location': 'Train Station',
        'date': 'Apr 22, 2025',
        'time': '17:30',
        'peopleCount': 935,
        'accuracy': 93.7,
        'type': 'Video',
      },
    ];

    // Apply filters
    final filteredResults =
        results.where((result) {
          // Apply search filter
          if (_searchQuery.isNotEmpty &&
              !result['location']!.toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              )) {
            return false;
          }

          // Apply type filter
          if (_selectedFilter != 'All types' &&
              result['type'] != _selectedFilter) {
            return false;
          }

          return true;
        }).toList();

    // Apply sorting
    switch (_selectedSort) {
      case 'Oldest first':
        // This is simplified - in a real app, you'd sort by actual date objects
        break;
      case 'Highest count':
        filteredResults.sort(
          (a, b) =>
              (b['peopleCount'] as int).compareTo(a['peopleCount'] as int),
        );
        break;
      case 'Lowest count':
        filteredResults.sort(
          (a, b) =>
              (a['peopleCount'] as int).compareTo(b['peopleCount'] as int),
        );
        break;
      case 'Newest first':
      default:
        // Already sorted newest first in our mock data
        break;
    }

    // If no results after filtering
    if (filteredResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 48.sp,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your filters or search terms',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // Build the list view for mobile instead of grid
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredResults.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final result = filteredResults[index];
        return AnalysisResultCard(
          location: result['location'] as String,
          date: result['date'] as String,
          time: result['time'] as String,
          peopleCount: result['peopleCount'] as int,
          accuracy: result['accuracy'] as double,
          type: result['type'] as String,
          onDownload: () {
            _handleDownload(result['id'] as String);
          },
          onShare: () {
            _handleShare(result['id'] as String);
          },
        );
      },
    );
  }

  /// Handle download action
  void _handleDownload(String resultId) {
    // In a real app, this would trigger a download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading result #$resultId'),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle share action
  void _handleShare(String resultId) {
    // In a real app, this would open a share dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing result #$resultId'),
        backgroundColor: AppTheme.surfaceColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
