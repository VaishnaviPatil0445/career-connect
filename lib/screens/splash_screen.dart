import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'main_navigation_screen.dart';

/// Neo-Brutalist Splash Screen for CareerConnect.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neoBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Neo-Brutal Icon Box
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.neoYellow,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.neoBlack, width: 3),
                      boxShadow: AppColors.neoShadow(offset: 6),
                    ),
                    child: const Icon(
                      Icons.work_rounded,
                      color: AppColors.neoBlack,
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App Name
                  const Text(
                    'CareerConnect',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.neoBlack,
                      letterSpacing: -0.6,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  const Text(
                    'Find jobs. Find opportunities.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Neo Loading Indicator Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.neoBlack, width: 2),
                      boxShadow: AppColors.neoShadow(offset: 2.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.neoBlack),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Loading catalog...',
                          style: TextStyle(
                            color: AppColors.neoBlack,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Footer Badge
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.neoCyan,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.neoBlack, width: 1.5),
                    boxShadow: AppColors.neoShadow(offset: 2),
                  ),
                  child: const Text(
                    'Student & Fresher Job Portal',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neoBlack,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
