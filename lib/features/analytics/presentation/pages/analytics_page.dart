import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/config/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_sidebar.dart';
import '../../../dashboard/presentation/widgets/chart_container.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/period_selector.dart';

/// Analytics page for the Ru'yaAI application
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedPeriod = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Analytics'),
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
                'Comprehensive insights and trends from your analyses',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 16.h),

              // Period selector
              PeriodSelector(
                options: const ['Daily', 'Weekly', 'Monthly'],
                selectedOption: _selectedPeriod,
                onOptionSelected: (period) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
              ),

              SizedBox(height: 16.h),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.file_download_outlined),
                    label: const Text('Export Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.insert_chart_outlined),
                    label: const Text('Create Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Stats cards - stacked vertically for mobile
              AnalyticsStatCard(
                title: 'Total Counted',
                value: '15,426',
                subtitle: '+12.5% from last week',
                trend: 12.5,
              ),

              SizedBox(height: 12.h),

              AnalyticsStatCard(
                title: 'Peak Day',
                value: 'Saturday',
                subtitle: '647 people counted',
              ),

              SizedBox(height: 12.h),

              AnalyticsStatCard(
                title: 'Weekly Average',
                value: '2,204',
                subtitle: 'Per day',
              ),

              SizedBox(height: 16.h),

              // Weekly trend chart
              ChartContainer(
                title: 'Weekly Trend',
                child: SizedBox(height: 200.h, child: _buildWeeklyTrendChart()),
              ),

              SizedBox(height: 16.h),

              // Location distribution
              ChartContainer(
                title: 'Location Distribution',
                child: SizedBox(height: 200.h, child: _buildLocationBarChart()),
              ),

              SizedBox(height: 16.h),

              // Recent peaks
              ChartContainer(
                title: 'Recent Peaks',
                child: SizedBox(height: 200.h, child: _buildRecentPeaksList()),
              ),

              SizedBox(height: 80.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 5),
    );
  }

  /// Build the weekly trend line chart
  Widget _buildWeeklyTrendChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 200,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final index = value.toInt();
                if (index >= 0 && index < days.length) {
                  return Text(
                    days[index],
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 10.sp,
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 200,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 10.sp,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 200),
              FlSpot(1, 300),
              FlSpot(2, 250),
              FlSpot(3, 280),
              FlSpot(4, 350),
              FlSpot(5, 500),
              FlSpot(6, 400),
            ],
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.3),
                  const Color(0xFF2563EB).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppTheme.surfaceColor,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  '${touchedSpot.y.toInt()} people',
                  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  /// Build the location bar chart
  Widget _buildLocationBarChart() {
    const locations = [
      'Main Plaza',
      'Food Court',
      'Entrance A',
      'Entrance B',
      'Venue Floor',
    ];
    const values = [400, 300, 210, 180, 150];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 450,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppTheme.surfaceColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${values[groupIndex]} people',
                TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < locations.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      locations[index],
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 9.sp,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 10.sp,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          locations.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index].toDouble(),
                width: 12.w,
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.r),
                  topRight: Radius.circular(6.r),
                ),
              ),
            ],
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.1), strokeWidth: 1);
          },
        ),
      ),
    );
  }

  /// Build the recent peaks list
  Widget _buildRecentPeaksList() {
    final peakItems = [
      {
        'location': 'Main Plaza',
        'day': 'Saturday',
        'time': '14:30',
        'count': 426,
      },
      {
        'location': 'Food Court',
        'day': 'Saturday',
        'time': '12:15',
        'count': 312,
      },
      {
        'location': 'Entrance A',
        'day': 'Friday',
        'time': '17:45',
        'count': 215,
      },
      {
        'location': 'Entrance B',
        'day': 'Friday',
        'time': '17:30',
        'count': 198,
      },
    ];

    return ListView.separated(
      itemCount: peakItems.length,
      separatorBuilder:
          (context, index) =>
              Divider(color: Colors.white.withOpacity(0.1), height: 1.h),
      itemBuilder: (context, index) {
        final item = peakItems[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['location'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${item['day']}, ${item['time']}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16.sp,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${item['count']}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
