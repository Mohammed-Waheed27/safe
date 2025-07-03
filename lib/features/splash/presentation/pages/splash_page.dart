import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_theme.dart';

/// Splash screen that handles initial app loading and authentication check
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthenticationStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

    Future<void> _checkAuthenticationStatus() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));

    try {
      print('🔍 Splash: Starting authentication check...');
      
      // Wait a bit more to ensure Firebase is fully initialized
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check if user is currently signed in
      print('🔍 Splash: Checking Firebase Auth current user...');
      final User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (!mounted) {
        print('❌ Splash: Widget no longer mounted, stopping auth check');
        return;
      }

      if (currentUser != null) {
        print('✅ Splash: User is signed in with UID: ${currentUser.uid}');
        print('📧 Splash: User email: ${currentUser.email}');
        // User is signed in, navigate to dashboard
        Navigator.pushReplacementNamed(context, AppRouter.dashboard);
      } else {
        print('❌ Splash: No user signed in, navigating to login');
        // No user signed in, navigate to login
        Navigator.pushReplacementNamed(context, AppRouter.login);
      }
    } catch (e, stackTrace) {
      print('❌ Splash: Error checking auth status: $e');
      print('📋 Splash: Stack trace: $stackTrace');
      
      // Error checking auth status, navigate to login
      if (mounted) {
        print('🔄 Splash: Navigating to login due to error');
        Navigator.pushReplacementNamed(context, AppRouter.login);
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
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Icon
                    Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.bar_chart,
                        color: AppTheme.primaryColor,
                        size: 60.sp,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // App Name
                    Text(
                      'Ru\'yaAI',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Tagline
                    Text(
                      'ذكاء اصطناعي لتحليل الحشود',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 60.h),

                    // Loading indicator
                    SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.8),
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
