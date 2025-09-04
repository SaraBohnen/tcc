// lib/views/splash_screen.dart

import 'dart:async';
import 'package:app_chain_view/views/start/start_gate.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'metrics_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    Timer(const Duration(milliseconds: 3000), () {
      // Substitua a rota para MetricsScreen:
      Navigator.pushReplacementNamed(context, StartGate.routeName);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            AppStrings.splashSlogan,
            style: AppStyles.splashTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
