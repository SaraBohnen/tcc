
import 'package:app_chain_view/views/wallet_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_chain_view/services/prefs_service.dart';
import 'package:app_chain_view/views/onboarding/onboarding_screen.dart';
import 'package:app_chain_view/views/splash_screen.dart';
import 'package:app_chain_view/views/metrics_screen.dart';

class StartGate extends StatefulWidget {
  static const routeName = '/'; // raiz pós-login
  const StartGate({super.key});

  @override
  State<StartGate> createState() => _StartGateState();
}

class _StartGateState extends State<StartGate> {
  final _prefs = PrefsService();

  @override
  void initState() {
    super.initState();
    // Decisão após o primeiro frame para evitar conflitos de build/navegação
    WidgetsBinding.instance.addPostFrameCallback((_) => _decide());
  }

  Future<void> _decide() async {
    // 1) Onboarding
    final doneOnboarding = await _prefs.isOnboardingDone();

    // 2) Endereço de carteira salvo (SharedPreferences)
    final sp = await SharedPreferences.getInstance();
    final wallet = sp.getString('walletAddress')?.trim();

    if (!mounted) return;

    if (!doneOnboarding) {
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
      return;
    }

    // Opcional: mostrar splash por ~1.2s quando já concluiu onboarding
    await Future.delayed(const Duration(milliseconds: 1200));

    if (wallet == null || wallet.isEmpty) {
      // Primeiro acesso pós-onboarding: pedir carteira
      Navigator.of(context).pushReplacementNamed(WalletSetupScreen.routeName);
    } else {
      // Carteira já vinculada: seguir para métricas
      Navigator.of(context).pushReplacementNamed(MetricsScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Splash apenas visual; a navegação é decidida em _decide()
    return const SplashScreen();
  }
}
