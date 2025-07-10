import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miun_live/core/theme/appthme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'features/auth/pages/login_page.dart';
import 'features/live feed/pages/search rooms/search_active_feeds.dart';
import 'core/services/auth_service.dart';

 void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await permission();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Phone Live',
          theme: AppTheme.lightTheme,
          home: StreamBuilder<User?>(
            stream: AuthService.authStateChanges,
            builder: (context, snapshot) {
              // Show loading while checking auth state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFF1A1A1A),
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
                  ),
                );
              }

              // Show login page if not authenticated
              if (snapshot.data == null) {
                return const LoginPage();
              }

              // Show main app if authenticated
              return searchActiveFeeds();
            },
          ),
        );
      },
    );
  }
}

Future<void> permission() async {
  final camerastate = await Permission.camera.request();
  final micstates = await Permission.microphone.request();
  debugPrint('Camera permission: $camerastate');
  debugPrint('Microphone permission: $micstates');
}
