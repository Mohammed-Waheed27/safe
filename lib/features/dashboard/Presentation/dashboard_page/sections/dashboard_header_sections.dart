import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardHeaderSections extends StatelessWidget {
  const DashboardHeaderSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Dashboard Regions",
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: const Color.fromARGB(255, 44, 44, 44),
                fontSize: 30.sp,
              ),
        ),
      ),
      SizedBox(
        height: 8.h,
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 300.w,
          child: Text(
            "Monitor and manage your security infrastructure.",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: const Color.fromARGB(255, 44, 44, 44),
                fontWeight: FontWeight.bold),
          ),
        ),
      )
    ]);
  }
}
