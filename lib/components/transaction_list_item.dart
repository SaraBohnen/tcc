// lib/components/transaction_list_item.dart
// Item visual de transação – formatação e badges de status/direção

import 'package:app_chain_view/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction tx;
  final VoidCallback? onTap;

  const TransactionListItem({super.key, required this.tx, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dt = DateFormat('dd/MM/yyyy • HH:mm').format(tx.timestamp);
    final isIn = tx.direction == TxDirection.inbound;
    final sign = isIn ? '+' : '-';
    final amountStr = '$sign${tx.amount.toStringAsFixed(6)} ${tx.tokenSymbol}';
    final feeStr = 'Taxa: ${tx.fee.toStringAsFixed(6)}';

    final statusChip = switch (tx.status) {
      TxStatus.pending => _chip('Pendente', Colors.orange),
      TxStatus.failed => _chip('Falhou', Colors.red),
      TxStatus.confirmed => _chip('Confirmada', Colors.green),
    };

    final dirIcon = isIn ? Icons.call_received : Icons.call_made;
    final dirColor = isIn ? Colors.green : Colors.red;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: dirColor.withOpacity(0.12),
        child: Icon(dirIcon, color: dirColor),
      ),
      title: Text(
        amountStr,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '$dt • ${tx.network}\n${_shortHash(tx.hash)}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          statusChip,
          const SizedBox(height: 6),
          Text(
            feeStr,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _shortHash(String h) =>
      h.length <= 12 ? h : '${h.substring(0, 6)}…${h.substring(h.length - 4)}';
}
