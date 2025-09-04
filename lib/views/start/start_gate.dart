import 'package:flutter/material.dart';
import '../../services/prefs_service.dart';

class StartGate extends StatelessWidget {
  const StartGate({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PrefsService().isOnboardingDone(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final done = snap.data ?? false;
        // Se já fez o onboarding, vá para login (ou home). Senão, vá para o onboarding.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(
            context,
            done ? '/login' : '/onboarding',
          );
        });
        return const SizedBox.shrink();
      },
    );
  }
}
