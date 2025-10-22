// lib/views/start/login_screen.dart
// UI: "Pular" abre diálogo. Se não houver biometria disponível, só mostra PIN.
// Comentários em pt-BR.
import 'package:app_chain_view/views/viewmodels/login_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_chain_view/views/start/start_gate.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  Future<void> _askAuthPreference(BuildContext context) async {
    final vm = context.read<LoginAuthViewModel>();

    // Se ainda não inicializou, faz init
    if (!vm.isSupported && !vm.isAuthenticating) {
      await vm.init();
    }

    // Sem biometria disponível: força caminho do PIN
    if (!vm.hasBiometrics) {
      final ok = await vm.authenticateWithDeviceCredential(
        reason: 'Use your device PIN to continue',
      );
      if (!context.mounted) return;
      _handleResult(context, ok, vm);
      return;
    }

    // Com biometria disponível: oferece escolha
    final choice = await showDialog<_AuthChoice>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ativar autenticação'),
          content: const Text(
            'Deseja ativar a autenticação usando a biometria ou o PIN do dispositivo?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(_AuthChoice.none),
              child: const Text('Agora não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(_AuthChoice.pin),
              child: const Text('PIN'),
            ),
            FilledButton.icon(
              onPressed: () =>
                  Navigator.of(context).pop(_AuthChoice.biometrics),
              icon: const Icon(Icons.fingerprint),
              label: const Text('Biometria'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || choice == null) return;

    bool ok = false;
    switch (choice) {
      case _AuthChoice.biometrics:
        ok = await vm.authenticateWithBiometrics(
          reason: 'Authenticate with biometrics to continue',
        );
        break;
      case _AuthChoice.pin:
        ok = await vm.authenticateWithDeviceCredential(
          reason: 'Use your device PIN to continue',
        );
        break;
      case _AuthChoice.none:
        ok = true; // segue sem ativar autenticação
        break;
    }

    if (!context.mounted) return;
    _handleResult(context, ok, vm);
  }

  // Trata o resultado: navega se ok; mostra erro se falhar
  void _handleResult(BuildContext context, bool ok, LoginAuthViewModel vm) {
    if (ok) {
      Navigator.of(context).pushReplacementNamed(StartGate.routeName);
    } else {
      final err =
          vm.lastError ??
          // dica comum: ausência de PIN cadastrado no dispositivo
          'Autenticação falhou. Verifique se há PIN/biometria configurados nas configurações do dispositivo.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // dispara init do VM após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<LoginAuthViewModel>();
      vm.init();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              const Center(
                child: Text(
                  "Bem-vindo!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Fazer Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.blueAccent, width: 2),
                ),
                child: const Text(
                  "Cadastrar",
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
              ),
              const Spacer(flex: 2),
              Center(
                child: GestureDetector(
                  onTap: () => _askAuthPreference(context),
                  child: Consumer<LoginAuthViewModel>(
                    builder: (_, vm, __) => Text(
                      vm.isAuthenticating ? "Verificando..." : "Pular",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum _AuthChoice { biometrics, pin, none }
