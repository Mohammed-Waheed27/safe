import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrsm/features/dashboard/Presentation/region_details_page/sections/buildrejionsanalytics.dart';
import '../../../../core/theme/colors/C.dart';
import '../dashboard_page/sections/dashboard_bar_sections.dart';
import 'sections/buildanalysistype.dart';
import 'sections/buildcameracard.dart';

class PopulaceAIDashboard extends StatelessWidget {
  const PopulaceAIDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --------------------
      // Custom AppBar
      // --------------------
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: C.primarybackgrond,
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: DashboardBarSections(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          color: C.secondarybackgrond,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------
              // Title & Subheading
              // --------------------
              Text(
                'North Sector',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: C.black),
              ),
              SizedBox(height: 4.h),
              Text(
                'Regional monitoring area with 3 cameras',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: C.grey2, fontSize: 15),
              ),
              SizedBox(height: 16.h),

              Buildanalysistype(),

              SizedBox(height: 16.h),

              // --------------------
              // Cameras (3) Title
              // --------------------
              Text(
                'Cameras (3)',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 12.h),

              // --------------------
              // Camera Card
              // --------------------
              Buildcameracard(),

              SizedBox(height: 24.h),

              // --------------------
              // Region Analytics
              // --------------------
              Text(
                'Region Analytics',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 12.h),
              Buildrejionsanalytics(),
            ],
          ),
        ),
      ),
    );
  }
}
