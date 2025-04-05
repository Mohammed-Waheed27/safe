import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../../../../core/theme/colors/C.dart';

enum AniProps { height, opacity }

class Buildanalysistype extends StatelessWidget {
  const Buildanalysistype({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = MovieTween();
    movie.scene(begin: Duration(seconds: 0), end: Duration(seconds: 1))
      ..tween(AniProps.height, Tween<double>(begin: 0.0, end: 160.h),
          curve: Curves.easeOut)
      ..tween(AniProps.opacity, Tween<double>(begin: 0.0, end: 0.0));
    // scound animation for the obacity=============================
    movie.scene(begin: Duration(seconds: 1), end: Duration(milliseconds: 1500))
      ..tween(AniProps.height, Tween<double>(begin: 160.0, end: 160.0),
          curve: Curves.easeOut)
      ..tween(AniProps.opacity, Tween<double>(begin: 0.0, end: 1.0));

    return CustomAnimationBuilder<Movie>(
        control: Control.play, // ابدأ الأنيميشن أوتوماتيك
        tween: movie, // ده الـMovieTween اللي عملناه
        duration: movie.duration, // إجمالي المدة (2 ثانية)
        builder: (context, value, child) {
          return Container(
            height: value.get(AniProps.height),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: C.primarybackgrond,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Opacity(
              opacity: value.get(AniProps.opacity),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analysis Type',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Standard Analysis',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: C.grey1,
                          ),
                          child: Text(
                            'Real-time monitoring with motion detection and standard alerts ',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
