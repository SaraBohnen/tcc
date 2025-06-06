// lib/views/wallet_screen.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo claro
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'Carteira',
          // style: AppStyles.screenTitle, // opcional
        ),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Lista de tokens/criptomoedas aparecerá aqui',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
