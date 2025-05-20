import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miun_live/core/theme/appthme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'features/live feed/pages/search rooms/search_active_feeds.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await permission();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'live stream app',
          theme: AppTheme.lightTheme,
          home: searchActiveFeeds(),
        );
      },
    );
  }
}

Future<void> permission() async {
  final camerastate = await Permission.camera.request();
  final micstates = await Permission.microphone.request();
}
