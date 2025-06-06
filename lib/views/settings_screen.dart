// lib/views/settings_screen.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo claro
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Configurações',
          // style: AppStyles.screenTitle, // opcional
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adicionar Carteira',
              style: AppStyles.screenTitle, // texto escuro
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: implementar fluxo para adicionar carteira
              },
              icon: const Icon(
                Icons.add_circle,
                color: AppColors.primaryWhite, // ícone branco sobre botão azul
              ),
              label: const Text('Nova Carteira'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.primaryWhite,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tema do App', style: AppStyles.screenTitle),
            const SizedBox(height: 8),
            SwitchListTile(
              title: Text(
                'Tema Claro',
                style: AppStyles.bodyText.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              value: true, // se quiser colocar lógica, substitua por variável
              onChanged: (bool value) {
                // TODO: implementar lógica de troca de tema
              },
              activeColor: AppColors.accentBlue,
            ),
            const SizedBox(height: 24),
            const Text('Idioma', style: AppStyles.screenTitle),
            const SizedBox(height: 8),
            DropdownButton<String>(
              dropdownColor: AppColors.primaryWhite,
              value: 'pt',
              items: const [
                DropdownMenuItem(value: 'pt', child: Text('Português')),
                DropdownMenuItem(value: 'en', child: Text('Inglês')),
              ],
              onChanged: (String? newLang) {
                // TODO: implementar troca de idioma
              },
            ),
          ],
        ),
      ),
    );
  }
}
