// lib/components/asset_pie_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:app_chain_view/models/metrics/asset_slice.dart';

class AssetPieChart extends StatefulWidget {
  final List<AssetSlice> data;

  const AssetPieChart({Key? key, required this.data}) : super(key: key);

  @override
  State<AssetPieChart> createState() => _AssetPieChartState();
}

class _AssetPieChartState extends State<AssetPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final double totalValue =
    widget.data.fold(0.0, (sum, item) => sum + item.value);

    if (widget.data.isEmpty) {
      return const Center(
        child: Text(
          'No data available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.6,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 0,
                  sections: _buildChartSections(totalValue),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(flex: 1, child: _buildLegend()),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(double totalValue) {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 110.0 : 100.0;
      final shadows = [const Shadow(color: Colors.black, blurRadius: 2)];

      final asset = widget.data[i];
      final percentage =
      totalValue > 0 ? (asset.value / totalValue) * 100 : 0.0;

      return PieChartSectionData(
        color: asset.color,
        value: asset.value,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.data
          .map((e) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Indicator(color: e.color, text: e.name),
      ))
          .toList(),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
  }) : super(key: key);

  final Color color;
  final String text;
  final bool isSquare;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isSquare ? BorderRadius.circular(4) : null,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
