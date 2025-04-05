import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrsm/core/theme/colors/C.dart';

import '../../../dashboard/Presentation/dashboard_page/sections/dashboard_bar_sections.dart';
import '../add_region/add_region_page.dart';
import 'widgets/regions_widgets.dart';

class RegionsConfigurationPage extends StatelessWidget {
  const RegionsConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.primarybackgrond,
      appBar: AppBar(
        title: DashboardBarSections(),
        backgroundColor: C.primarybackgrond,
        surfaceTintColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        color: C.secondarybackgrond,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Regions Configurations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 8.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddRegionPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 8.w),
                            Text(
                              'Add Region',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  RegionCard(
                    name: 'North Sector',
                    createdDate: 'Dec 16, 2024',
                    description: 'Monitoring area with custom alert settings',
                    analysisType: 'Standard Analysis',
                    camerasCount: 3,
                  ),
                  const SizedBox(height: 12),
                  RegionCard(
                    name: 'East Wing',
                    createdDate: 'Dec 16, 2024',
                    description: 'Monitoring area with custom alert settings',
                    analysisType: 'Standard Analysis',
                    camerasCount: 2,
                  ),
                  const SizedBox(height: 12),
                  RegionCard(
                    name: 'South Gate',
                    createdDate: 'Dec 16, 2024',
                    description: 'Monitoring area with custom alert settings',
                    analysisType: 'Standard Analysis',
                    camerasCount: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
