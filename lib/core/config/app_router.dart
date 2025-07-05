import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/live/presentation/pages/live_monitoring_page.dart';
import '../../features/live/presentation/pages/add_camera_page.dart';
import '../../features/analysis/presentation/pages/analysis_page.dart';
import '../../features/results/presentation/pages/results_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/zones/presentation/pages/zones_page.dart';
import '../../features/zones/presentation/pages/zone_live_view.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/zones/data/models/zone_model.dart';

/// Application routing configuration using standard Navigator
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String analytics = '/analytics';
  static const String liveMonitoring = '/live-monitoring';
  static const String addCamera = '/add-camera';
  static const String analysis = '/analysis';
  static const String results = '/results';
  static const String alerts = '/alerts';
  static const String zones = '/zones';
  static const String settings = '/settings';

  // Authentication state keys
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';
  static const String _userTokenKey = 'user_token';

  // Check if user is authenticated from SharedPreferences
  static Future<bool> get isAuthenticated async {
    final prefs = GetIt.I<SharedPreferences>();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get current user ID
  static Future<String?> get currentUserId async {
    final prefs = GetIt.I<SharedPreferences>();
    return prefs.getString(_userIdKey);
  }

  // Get current user token
  static Future<String?> get currentUserToken async {
    final prefs = GetIt.I<SharedPreferences>();
    return prefs.getString(_userTokenKey);
  }

  // Define app routes for named routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      signup: (context) => const SignupPage(),
      dashboard: (context) => const DashboardPage(),
      analytics: (context) => const AnalyticsPage(),
      liveMonitoring: (context) => const LiveMonitoringPage(),
      addCamera: (context) => const AddCameraPage(),
      analysis: (context) => const AnalysisPage(),
      results: (context) => const ResultsPage(),
      alerts: (context) => const AlertsPage(),
      zones: (context) => const ZonesPage(),
      settings: (context) => const SettingsPage(),
    };
  }

  // Authentication helpers
  static Future<void> loginUser(
    BuildContext context, {
    required String userId,
    required String userToken,
  }) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userTokenKey, userToken);

    if (context.mounted) {
      navigateToReplacingAll(context, dashboard);
    }
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = GetIt.I<SharedPreferences>();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userTokenKey);

    if (context.mounted) {
      navigateToReplacingAll(context, login);
    }
  }

  // Simple direct navigation method
  static Future<void> navigateTo(BuildContext context, Widget page) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => page));
  }

  // Simple navigation methods with route names
  static void navigateToNamed(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  static void navigateToReplacing(BuildContext context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  static void navigateToReplacingAll(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }

  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/zones':
        return MaterialPageRoute(builder: (_) => const ZonesPage());
      case '/zones/live':
        final zone = settings.arguments as ZoneModel;
        // Use the zone's specific token instead of default
        final token =
            zone.zoneToken.isNotEmpty
                ? zone.zoneToken
                : (dotenv.env['main_token'] ??
                    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI5YjQ4ODEwOC0wNjk0LTQ1ZGMtOGM2ZC1hNzQ1NmY1MGEzN2QiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcwODk2MzU0MSwiZXhwIjoxNzE2NzM5NTQxfQ.BruXhAuGULv-BW-8KQIjPNa8u3DjZhDL8YCUW6YSyGU');

        return MaterialPageRoute(
          builder:
              (_) =>
                  ZoneLiveView(zone: zone, token: token, roomId: zone.roomId!),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
