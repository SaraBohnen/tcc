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

/// Gráfico de linha usando FL Chart
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
  })  : areaColor = areaColor ?? AppColors.accentBlue,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    // Use índice como eixo X para evitar "escapar" do gráfico
    final spots = List.generate(
      data.length,
          (i) => FlSpot(i.toDouble(), data[i].value),
    );

    // Y bounds + padding
    final values = data.map((e) => e.value).toList();
    double minY = values.reduce((a, b) => a < b ? a : b);
    double maxY = values.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    if (range == 0) {
      minY -= 1;
      maxY += 1;
    } else {
      final pad = range * 0.1;
      minY -= pad;
      maxY += pad;
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          // NÃO exibir datas no eixo X
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: ((maxY - minY) / 4).clamp(0.0001, double.infinity),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
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
                final idx = spot.spotIndex;
                final date = data[idx].date;
                final val = data[idx].value;
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
