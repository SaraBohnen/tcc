import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Data model for each slice of the pie chart.
/// Using a class improves type safety and code readability.
class AssetData {
  final String name;
  final double value; // Represents the balance or total amount
  final Color color;

  AssetData({required this.name, required this.value, required this.color});
}

/// A reusable and simplified pie chart widget that directly displays the data it receives.
/// It expects the data to be pre-processed (e.g., top 6 assets + "Others").
class AssetPieChart extends StatefulWidget {
  final List<AssetData> data;

  const AssetPieChart({Key? key, required this.data}) : super(key: key);

  @override
  State<AssetPieChart> createState() => _AssetPieChartState();
}

class _AssetPieChartState extends State<AssetPieChart> {
  int touchedIndex = -1;

  // The data processing logic has been removed. This widget is now much simpler.
  // It will directly use `widget.data` for building the chart and legend.

  @override
  Widget build(BuildContext context) {
    // The total value is needed to calculate the percentage for the title.
    // We now use `widget.data` directly.
    final double totalValue = widget.data.fold(
      0.0,
      (sum, item) => sum + item.value,
    );

    // Return an empty container if there is no data to display.
    if (widget.data.isEmpty) {
      return const Center(
        child: Text(
          'No data available.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.6, // Adjusted for better layout with legend
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
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
                            pieTouchResponse
                                .touchedSection!
                                .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
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

  /// Builds the list of `PieChartSectionData` from `widget.data`.
  List<PieChartSectionData> _buildChartSections(double totalValue) {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      final shadows = [const Shadow(color: Colors.black, blurRadius: 2)];

      final asset = widget.data[i];
      // Calculate percentage only if totalValue is not zero to avoid errors.
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

  /// Builds the legend on the side of the chart from `widget.data`.
  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          widget.data.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Indicator(color: data.color, text: data.name),
            );
          }).toList(),
    );
  }
}

/// A simple legend indicator widget.
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
