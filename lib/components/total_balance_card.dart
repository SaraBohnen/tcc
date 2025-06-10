// lib/components/total_balance_card.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Componente que exibe o painel com o saldo total
class TotalBalanceCard extends StatelessWidget {
  final double totalBalance;
  final String title;

  const TotalBalanceCard({
    Key? key,
    required this.totalBalance,
    this.title = 'Total',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.screenTitle),
          const SizedBox(height: 8),
          Text(
            'R\$ ${totalBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
