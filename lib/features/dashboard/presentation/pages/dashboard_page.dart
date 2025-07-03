import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ru2ya/features/mobiel%20cam%20feed/presentation/pages/start_feed_view/start_feed_view.dart'
    show StartFeedView;

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_theme.dart';
import '../../../analysis/presentation/pages/analysis_page.dart';
import '../../../live/presentation/pages/live_monitoring_page.dart';
import '../../../results/presentation/pages/results_page.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/chart_container.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/recent_analysis_item.dart';

/// Dashboard page for the Ru'yaAI application
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text('Ru\'yaAI Dashboard'),
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
          IconButton(
            onPressed: () => AppRouter.logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'View your analytics and run new analyses',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),

              SizedBox(height: 24.h),

              // Stat cards - stacked for mobile
              DashboardCard(
                title: 'Total People Counted',
                value: '15,426',
                description: 'Last 7 days',
                trend: '+12.5% from last week',
                isTrendPositive: true,
                icon: Icons.groups_outlined,
              ),

              SizedBox(height: 12.h),

              DashboardCard(
                title: 'Analyses Run',
                value: '24',
                description: 'Last 7 days',
                trend: 'Same as last week',
                isTrendPositive: null,
                icon: Icons.bar_chart_outlined,
              ),

              SizedBox(height: 12.h),

              DashboardCard(
                title: 'Peak Crowd Size',
                value: '1,254',
                description: 'Last 7 days',
                trend: '+23.1% from last week',
                isTrendPositive: true,
                icon: Icons.people_outlined,
              ),

              SizedBox(height: 24.h),

              // Weekly trend chart
              ChartContainer(
                title: 'Weekly Crowd Trends',
                child: SizedBox(height: 200.h, child: _buildWeeklyTrendChart()),
              ),

              SizedBox(height: 16.h),

              // Location distribution chart
              ChartContainer(
                title: 'Crowd by Location',
                child: SizedBox(height: 200.h, child: _buildLocationBarChart()),
              ),

              SizedBox(height: 16.h),

              // New analysis section
              _buildNewAnalysisCard(context),

              SizedBox(height: 16.h),

              // Recent analyses
              _buildRecentAnalysesCard(context),

              SizedBox(height: 80.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppSidebar(currentIndex: 0),
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

  /// Build the new analysis card
  Widget _buildNewAnalysisCard(BuildContext context) {
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
            'New Analysis',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          // Upload button
          _buildAnalysisOption(
            context,
            icon: Icons.upload_file_outlined,
            title: 'Upload Image/Video',
            onTap:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AnalysisPage()),
                ),
          ),
          SizedBox(height: 12.h),
          // Connect camera button
          _buildAnalysisOption(
            context,
            icon: Icons.videocam_outlined,
            title: 'Connect Live Camera',
            onTap:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveMonitoringPage(),
                  ),
                ),
          ),
          SizedBox(height: 12.h),
          // Scan QR code button
          _buildAnalysisOption(
            context,
            icon: Icons.qr_code_scanner_outlined,
            title: 'Scan QR Code to Add Camera',
            onTap: () => Navigator.pushNamed(context, AppRouter.addCamera),
          ),
          SizedBox(height: 16.h),
          _buildAnalysisOption(
            context,
            icon: Icons.mobile_screen_share_rounded,
            title: "show live feeds from mobile camera",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartFeedView()),
              );
            },
          ),
          SizedBox(height: 16.h),

          // Start analysis button
          ElevatedButton(
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AnalysisPage()),
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Center(
              child: Text(
                'Start New Analysis',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build an analysis option
  Widget _buildAnalysisOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.white),
            SizedBox(width: 12.w),
            Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// Build the recent analyses card
  Widget _buildRecentAnalysesCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Analyses',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed:
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultsPage(),
                      ),
                    ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Analysis items
          const RecentAnalysisItem(
            title: 'Concert Venue',
            date: 'Apr 25, 2025',
            type: 'Image',
            count: 1254,
          ),
          SizedBox(height: 12.h),
          const RecentAnalysisItem(
            title: 'Main Square',
            date: 'Apr 24, 2025',
            type: 'Video',
            count: 352,
          ),
        ],
      ),
    );
  }
}
