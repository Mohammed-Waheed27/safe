import 'package:flutter/material.dart';
import 'package:hrsm/core/theme/colors/C.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.orange1,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 40,
      height: 40,
      child: Center(
        child: Text(
          "P",
          style: TextStyle(fontSize: 30, color: C.primarybackgrond),
        ),
      ),
    );
  }
}
