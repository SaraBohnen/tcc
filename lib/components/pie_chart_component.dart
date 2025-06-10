// lib/components/pie_chart_component.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';

/// Modelo para dados do gráfico de pizza
class PieChartData {
  final String label;
  final double value;
  final double percentage;
  final Color color;

  PieChartData({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
  });
}

/// Widget de gráfico de pizza reutilizável
class CustomPieChart extends StatefulWidget {
  final List<PieChartData> data;
  final double radius;
  final bool showLabels;
  final bool showLegend;

  const CustomPieChart({
    Key? key,
    required this.data,
    this.radius = 80,
    this.showLabels = true,
    this.showLegend = true,
  }) : super(key: key);

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    return Column(
      children: [
        // Gráfico de pizza
        SizedBox(
          height: widget.radius * 2.5,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: _buildPieChartSections(),
            ),
          ),
        ),

        // Legenda (se habilitada)
        if (widget.showLegend) ...[const SizedBox(height: 16), _buildLegend()],
      ],
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? widget.radius + 10 : widget.radius;

      return PieChartSectionData(
        color: data.color,
        value: data.value,
        title:
            widget.showLabels ? '${data.percentage.toStringAsFixed(1)}%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children:
          widget.data.map((data) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: data.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${data.label} (${data.percentage.toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
