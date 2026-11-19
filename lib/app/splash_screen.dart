import 'package:flutter/material.dart';

import 'navigation/main_navigation.dart';
import 'theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      setState(() => _showLogo = true);
    });

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedOpacity(
          opacity: _showLogo ? 1 : 0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          child: AnimatedScale(
            scale: _showLogo ? 1 : 0.88,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            child: Image.asset(
              'assets/images/logo_white.png',
              width: MediaQuery.sizeOf(context).width * 0.75,
            ),
          ),
        ),
      ),
    );
  }
}
