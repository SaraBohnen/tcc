// lib/views/splash_screen.dart
// Navega para a tela de Login após a animação (inalterado, apenas mantém a rota).
import 'package:app_chain_view/views/login_screen.dart';
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

    _ac.addStatusListener((status) async {
      if (status == AnimationStatus.completed && mounted) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    });

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
