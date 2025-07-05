import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ru2ya/firebase_options.dart';

import 'core/config/app_router.dart';
import 'core/config/app_theme.dart';
import 'core/di/injection_container.dart' as di;
import 'core/util/bloc_observer.dart';
import 'core/util/firebase_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'features/zones/presentation/bloc/zone_bloc.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('🚀 App: Starting app initialization...');

    // Initialize Firebase
    print('🔥 App: Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ App: Firebase initialized successfully');

    // Load environment variables
    print('📁 App: Loading environment variables...');
    await dotenv.load(fileName: "environment/.env");
    print('✅ App: Environment variables loaded');

    // Request permissions
    print('🔐 App: Requesting permissions...');
    await ask_permision();
    print('✅ App: Permissions requested');

    // Set preferred orientations
    print('📱 App: Setting preferred orientations...');
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print('✅ App: Orientations set');

    // Initialize Hive for local storage
    print('💾 App: Initializing Hive...');
    await Hive.initFlutter();
    print('✅ App: Hive initialized');

    // Test Firebase connection
    print('🧪 App: Testing Firebase connection...');
    await FirebaseTest.testCompleteFirebaseConnection();

    // Initialize dependency injection
    print('🏗️ App: Initializing dependency injection...');
    await di.init();
    print('✅ App: Dependency injection initialized');

    // Set custom BLoC observer for better debugging
    Bloc.observer = AppBlocObserver();
    print('🎯 App: BLoC observer set');

    print('🚀 App: All initialization complete, starting app...');
    runApp(const RuyaApp());
  } catch (e, stackTrace) {
    print('❌ App: Initialization failed with error: $e');
    print('📋 App: Stack trace: $stackTrace');
    // Still try to run the app even if some initialization fails
    runApp(const RuyaApp());
  }
}

class RuyaApp extends StatelessWidget {
  const RuyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size based on mobile layout (375x812 - iPhone X/XS dimensions)
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (context) => di.getIt<ZoneBloc>())],
          child: MaterialApp(
            title: 'Ru\'yaAI',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark, // Default to dark theme
            initialRoute: AppRouter.splash, // Start with splash screen
            routes: AppRouter.getRoutes(),
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder:
                    (context) => Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Page not found',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The page ${settings.name} does not exist',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed:
                                  () => Navigator.pushReplacementNamed(
                                    context,
                                    AppRouter.dashboard,
                                  ),
                              child: const Text('Go to Dashboard'),
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            },
          ),
        );
      },
    );
  }
}

Future<void> ask_permision() async {
  final camera = await Permission.camera.request();
  final mic = await Permission.microphone.request();
}
