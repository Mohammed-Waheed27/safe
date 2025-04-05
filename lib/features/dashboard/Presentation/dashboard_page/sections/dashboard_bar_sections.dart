import 'package:flutter/material.dart';
import 'package:hrsm/core/theme/colors/C.dart';

import '../widgets/logo.dart';

class DashboardBarSections extends StatelessWidget {
  const DashboardBarSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Logo(),
                SizedBox(
                  width: 10,
                ),
                Text("PopulaceAI",
                    style: Theme.of(context).textTheme.displayLarge)
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Icon(
                  Icons.notifications_none_outlined,
                  color: C.black,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.account_circle_outlined,
                  color: C.black,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
