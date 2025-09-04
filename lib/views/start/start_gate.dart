// lib/views/start/start_gate.dart
import 'package:flutter/material.dart';
import 'package:app_chain_view/services/prefs_service.dart';
import 'package:app_chain_view/views/onboarding/onboarding_screen.dart';
import 'package:app_chain_view/views/splash_screen.dart';
import 'package:app_chain_view/views/metrics_screen.dart';

class StartGate extends StatefulWidget {
  static const routeName = '/'; // raiz
  const StartGate({super.key});

  @override
  State<StartGate> createState() => _StartGateState();
}

class _StartGateState extends State<StartGate> {
  final _prefs = PrefsService();

  @override
  void initState() {
    super.initState();
    // decide após o primeiro frame (evita conflito com build)
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    final done = await _prefs.isOnboardingDone();
    if (!mounted) return;

    // (Opcional) mostre o splash por ~1.2s quando já concluiu o onboarding
    if (done) {
      await Future.delayed(const Duration(milliseconds: 1200));
      Navigator.of(context).pushReplacementNamed(MetricsScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Splash apenas visual (SEM navegação própria)
    return const SplashScreen();
  }
}
