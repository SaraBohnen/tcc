// lib/components/top_performers_table.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Modelo de dados para os tokens de melhor desempenho.
class TokenPerformanceData {
  final String name;
  final double price;
  final double sevenDayChange;

  TokenPerformanceData({
    required this.name,
    required this.price,
    required this.sevenDayChange,
  });
}

/// Um widget que exibe uma tabela com os tokens de melhor desempenho.
class TopPerformersTable extends StatelessWidget {
  final List<TokenPerformanceData> data;

  const TopPerformersTable({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatação para valores monetários (ex: $69,543.10)
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );
    // Estilo de texto para os cabeçalhos das colunas
    const headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.black87,
    );

    return DataTable(
      // Configurações visuais
      columnSpacing: 16.0,
      horizontalMargin: 0,
      headingRowHeight: 40,

      // Definição das colunas da tabela
      columns: const [
        DataColumn(label: Expanded(child: Text('Token', style: headerStyle))),
        DataColumn(
          label: Expanded(
            child: Center(child: Text('Preço', style: headerStyle)),
          ),
          numeric: true,
        ),
        DataColumn(
          label: Expanded(child: Center(child: Text('7d', style: headerStyle))),
          numeric: true,
        ),
      ],

      // Geração das linhas da tabela a partir dos dados recebidos
      rows:
          data.map((token) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    token.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                DataCell(
                  Center(child: Text(currencyFormatter.format(token.price))),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '${token.sevenDayChange.toStringAsFixed(1)}%',
                      style: TextStyle(
                        // Cor verde para alta, vermelho para baixa
                        color:
                            token.sevenDayChange >= 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
