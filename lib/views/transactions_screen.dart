// lib/views/transactions_screen.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo claro
      backgroundColor: AppColors.backgroundLight,
      body: const Center(
        child: Text(
          'Histórico de transações aparecerá aqui',
          style: TextStyle(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
