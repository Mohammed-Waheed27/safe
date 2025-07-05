import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_theme.dart';

/// Splash screen that shows app logo and checks authentication
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthenticationAndNavigate();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      // Check authentication status
      final isAuthenticated = await AppRouter.isAuthenticated;

      if (!mounted) return;

      if (isAuthenticated) {
        // User is logged in, go to dashboard
        AppRouter.navigateToReplacingAll(context, AppRouter.dashboard);
      } else {
        // User is not logged in, go to login
        AppRouter.navigateToReplacingAll(context, AppRouter.login);
      }
    } catch (e) {
      print('Error checking authentication: $e');
      // On error, default to login page
      if (mounted) {
        AppRouter.navigateToReplacingAll(context, AppRouter.login);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo placeholder
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.remove_red_eye,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 24.h),

              // App name
              Text(
                "Ru'yaAI",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              SizedBox(height: 8.h),

              // Tagline
              Text(
                'Smart Crowd Monitoring',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w300,
                ),
              ),

              SizedBox(height: 40.h),

              // Loading indicator
              SizedBox(
                width: 40.w,
                height: 40.w,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
