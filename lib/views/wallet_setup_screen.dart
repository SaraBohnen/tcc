// lib/views/wallet/wallet_setup_screen.dart
// Ajustado: valida carteira consultando SampleDataGenerator.isKnownWallet
// Comentários em pt-BR.

import 'package:app_chain_view/views/metrics_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/sample_data_generator.dart';

class WalletSetupScreen extends StatefulWidget {
  static const routeName = '/wallet_setup';

  const WalletSetupScreen({super.key});

  @override
  State<WalletSetupScreen> createState() => _WalletSetupScreenState();
}

class _WalletSetupScreenState extends State<WalletSetupScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSaving = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _basicFormatValid(String value) {
    final v = value.trim();
    final ethLike = RegExp(r'^0x[a-fA-F0-9]{40}$'); // EVM
    final bech32Like =
    RegExp(r'^[a-z0-9]{1,83}1[qpzry9x8gf2tvdw0s3jn54khce6mua7l]{8,}$'); // bech32
    return ethLike.hasMatch(v) || bech32Like.hasMatch(v);
  }

  Future<void> _saveAndContinue() async {
    final value = _controller.text.trim();

    // 1) Validação de formato
    if (value.isEmpty) {
      setState(() => _errorText = 'Informe o endereço da carteira.');
      return;
    }
    if (!_basicFormatValid(value)) {
      setState(() => _errorText = 'Endereço inválido. Verifique e tente novamente.');
      return;
    }

    // 2) Consulta ao SampleDataGenerator (fonte de verdade no ambiente de demo)
    final exists = SampleDataGenerator.isKnownWallet(value);
    if (!exists) {
      setState(() => _errorText = 'Carteira não encontrada no ambiente de demonstração.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Carteira desconhecida.\nUse uma destas:\n${SampleDataGenerator.knownWallets().join('\n')}',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('walletAddress', value);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Carteira salva com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushNamedAndRemoveUntil(
        MetricsScreen.routeName,
            (route) => false,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final demoList = SampleDataGenerator.knownWallets();

    return Scaffold(
      appBar: AppBar(title: const Text('Vincular carteira')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Informe o endereço da sua carteira para carregar as métricas.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              // Dica opcional com os endereços de demo
              Text(
                'Demonstração (endereços válidos):\n• ${demoList[0]}\n• ${demoList[1]}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Endereço da carteira',
                  hintText: 'Ex.: 0xabc123... ou bech32',
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
                autocorrect: false,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _saveAndContinue,
                icon: _isSaving
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.save),
                label: const Text('Salvar e continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
