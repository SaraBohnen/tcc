// lib/views/splash_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeIn);
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
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
