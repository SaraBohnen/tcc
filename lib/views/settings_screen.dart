import 'package:app_chain_view/views/metrics_charts_manager_screen.dart';
import 'package:app_chain_view/views/wallet_setup_screen.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  // 🔹 Mostra Toast (SnackBar) simples no rodapé
  void _showDevToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Funcionalidade em desenvolvimento.',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adicionar Carteira',
              style: AppStyles.screenTitle,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(WalletSetupScreen.routeName);
              },
              icon: const Icon(
                Icons.add_circle,
                color: AppColors.primaryWhite,
              ),
              label: const Text('Nova Carteira'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.primaryWhite,
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Gráficos da Tela de Métricas',
              style: AppStyles.screenTitle,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(MetricsChartsManagerScreen.routeName);
              },
              icon: const Icon(
                Icons.edit,
                color: AppColors.primaryWhite,
              ),
              label: const Text('Gerenciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.primaryWhite,
              ),
            ),
            const SizedBox(height: 24),

            const Text('Tema do App', style: AppStyles.screenTitle),
            const SizedBox(height: 8),

            // 🔹 Permite que o clique em qualquer área do SwitchListTile dispare o toast
            InkWell(
              onTap: () => _showDevToast(context),
              child: IgnorePointer(
                // impede a interação direta com o switch (somente exibe o toast)
                child: SwitchListTile(
                  title: Text(
                    'Tema Claro',
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  value: true,
                  onChanged: (_) {},
                  activeColor: AppColors.accentBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
