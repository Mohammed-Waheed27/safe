import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrsm/core/theme/colors/C.dart';
import 'package:hrsm/features/dashboard/Presentation/dashboard_page/sections/dashboard_header_sections.dart';

import 'sections/dashboard_bar_sections.dart';
import 'widgets/dashboard_info_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          shadowColor: C.grey1,
          backgroundColor: C.primarybackgrond,
          title: DashboardBarSections(),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: C.secondarybackgrond,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                DashboardHeaderSections(),
                DashboardInfoWidget(),
                DashboardInfoWidget(),
                DashboardInfoWidget(),
                DashboardInfoWidget(),
              ],
            ),
          ),
        ));
  }
}
