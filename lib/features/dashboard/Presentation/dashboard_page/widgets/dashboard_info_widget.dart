import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors/C.dart';
import '../../region_details_page/PopulaceAIDashboard.dart';

class DashboardInfoWidget extends StatelessWidget {
  const DashboardInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PopulaceAIDashboard()));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.all(10.w),
        height: 230.h,
        width: 400.w,
        decoration: BoxDecoration(
          color: C.primarybackgrond,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "North Sector",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 20.sp,
                      ),
                ),
                Container(
                  width: 90.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                      color: C.grey1, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 15,
                      ),
                      Text(
                        "3 Cameras",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: C.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Analysis Type",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(),
              ),
            ),
            //===================
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              height: 80.h,
              decoration: BoxDecoration(
                  color: C.orange2, borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.network_cell_outlined,
                        color: C.orange1,
                        size: 20,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "Advanced Analytics",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: C.orange1, fontSize: 18.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Container(
                      height: 25,
                      decoration: BoxDecoration(
                          color: C.orange3,
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                        child: Text(
                          "Computer vision with object detection and crowd analysis",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: C.black),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                  color: C.orange1, borderRadius: BorderRadius.circular(4)),
              height: 50.h,
              child: Center(
                child: Text(
                  "Show Details",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: C.primarybackgrond, fontSize: 18.sp),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
