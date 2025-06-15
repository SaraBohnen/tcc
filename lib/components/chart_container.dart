// lib/components/chart_container.dart

import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Container reutilizável para exibir gráficos com título e padding padrão
class ChartContainer extends StatelessWidget {
  final String title;
  final Widget chart;
  final double? height;
  final EdgeInsets? padding;

  const ChartContainer({
    Key? key,
    required this.title,
    required this.chart,
    this.height = 270,
    this.padding,
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
      padding: padding ?? const EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(title, style: AppStyles.screenTitle),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: chart,
            ),
          ),
        ],
      ),
    );
  }
}
