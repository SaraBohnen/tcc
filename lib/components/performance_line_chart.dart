// lib/components/performance_line_chart.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

/// Modelo para cada ponto de desempenho (data + valor)
class PerformanceData {
  final DateTime date;
  final double value;
  PerformanceData(this.date, this.value);
}

/// Widget que exibe o gráfico de linha usando FL Chart,
/// recebendo uma lista de [PerformanceData].
class PerformanceLineChart extends StatelessWidget {
  final List<PerformanceData> data;
  final String title;
  final Color lineColor;
  final Color areaColor;

  const PerformanceLineChart({
    Key? key,
    required this.data,
    this.title = 'Desempenho da Carteira',
    this.lineColor = AppColors.accentBlue,
    Color? areaColor,
  }) : areaColor = areaColor ?? AppColors.accentBlue,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    // Base para converter datas em dias desde o início
    final baseDate = data.first.date;
    final spots =
        data.map((pd) {
          final x = pd.date.difference(baseDate).inDays.toDouble();
          return FlSpot(x, pd.value);
        }).toList();

    // Encontrar minY e maxY
    final values = data.map((e) => e.value).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox();
                final date = data[index].date;
                final label = DateFormat('dd/MM').format(date);
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
              interval: (maxY - minY) / 4,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: AppColors.textSecondary),
            bottom: BorderSide(color: AppColors.textSecondary),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: lineColor,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: areaColor.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = data[spot.spotIndex].date;
                final val = data[spot.spotIndex].value;
                final formattedDate = DateFormat('dd/MM/yyyy').format(date);
                return LineTooltipItem(
                  '$formattedDate\nR\$ ${val.toStringAsFixed(2)}',
                  const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
