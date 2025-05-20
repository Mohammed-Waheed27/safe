import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ru2ya/features/mobiel%20cam%20feed/data/api_call.dart';
import 'package:ru2ya/features/mobiel%20cam%20feed/presentation/pages/live%20feed%20view/live_feed_view.dart';

import '../../../../widgets/custom_button.dart';

class StartFeedView extends StatelessWidget {
  const StartFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Feed'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "in order to listen to the feeds, you need to start the server first",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: GestureDetector(
                    child: CustomButton(
                      text: 'Start Feed server',
                      onPressed: () async {
                        await createMeeting().then((meetingId) {
                          if (!context.mounted) return;
                          createfeed_id(meetingId);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => LiveFeedView(
                                    meetingId: meetingId,
                                    token: token,
                                  ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
