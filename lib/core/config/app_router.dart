import 'package:flutter/material.dart';

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
import '../../features/settings/presentation/pages/settings_page.dart';

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

  // Authentication state - for demo purposes only
  // In a real app, this would come from a state management solution
  static bool isAuthenticated = true;

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
  static void loginUser(BuildContext context) {
    isAuthenticated = true;
    navigateToReplacingAll(context, dashboard);
  }

  static void logout(BuildContext context) {
    isAuthenticated = false;
    navigateToReplacingAll(context, login);
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
}
