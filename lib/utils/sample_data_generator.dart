// lib/utils/sample_data_generator.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../components/performance_line_chart.dart';
import '../components/period_filter_dropdown.dart';
import '../components/pie_chart_component.dart';
import '../utils/constants.dart';

/// Classe utilitária para gerar dados de exemplo
/// Quando o backend estiver pronto, substitua por chamadas reais
class SampleDataGenerator {
  /// Gera dados de exemplo conforme o filtro selecionado
  static List<PerformanceData> generatePerformanceData(PeriodFilter filter) {
    final now = DateTime.now();
    late DateTime startDate;
    late int pointCount;

    switch (filter) {
      case PeriodFilter.last7Days:
        startDate = now.subtract(const Duration(days: 6));
        pointCount = 7;
        break;
      case PeriodFilter.last1Month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        pointCount = 30;
        break;
      case PeriodFilter.last3Months:
        startDate = DateTime(now.year, now.month - 3, now.day);
        pointCount = 45;
        break;
      case PeriodFilter.last1Year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        pointCount = 52;
        break;
    }

    final List<PerformanceData> data = [];
    for (int i = 0; i < pointCount; i++) {
      late DateTime pointDate;
      switch (filter) {
        case PeriodFilter.last7Days:
          pointDate = startDate.add(Duration(days: i));
          break;
        case PeriodFilter.last1Month:
          pointDate = startDate.add(Duration(days: i));
          break;
        case PeriodFilter.last3Months:
          final totalDays = now.difference(startDate).inDays;
          final step = totalDays / (pointCount - 1);
          pointDate = startDate.add(Duration(days: (step * i).round()));
          break;
        case PeriodFilter.last1Year:
          final totalDays = now.difference(startDate).inDays;
          final step = totalDays / (pointCount - 1);
          pointDate = startDate.add(Duration(days: (step * i).round()));
          break;
      }
      // Para fins didáticos, geramos um valor crescente linear
      final baseValue = 1200.0;
      final variation = (i * 20).toDouble();
      data.add(PerformanceData(pointDate, baseValue + variation));
    }

    return data;
  }

  /// Gera um valor de saldo total de exemplo
  static double generateTotalBalance() {
    // Valor placeholder - substitua por dados reais
    return 0.00;
  }

  /// Gera dados de exemplo para gráfico de tokens
  static List<PieChartData> generateTokensData() {
    final tokens = [
      {'symbol': 'BTC', 'value': 45.2},
      {'symbol': 'ETH', 'value': 25.8},
      {'symbol': 'SOL', 'value': 12.3},
      {'symbol': 'GRT', 'value': 6.1},
      {'symbol': 'COW', 'value': 4.2},
      {'symbol': 'TRX', 'value': 2.8},
      {'symbol': 'XRP', 'value': 1.9},
      {'symbol': 'LINK', 'value': 1.1},
      {'symbol': 'UNI', 'value': 0.4},
      {'symbol': 'TON', 'value': 0.2},
    ];

    final colors = [
      AppColors.accentBlue,
      Colors.orange,
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
      Colors.pink,
      Colors.cyan,
    ];

    return tokens.asMap().entries.map((entry) {
      final index = entry.key;
      final token = entry.value;
      return PieChartData(
        label: token['symbol'] as String,
        value: token['value'] as double,
        percentage: token['value'] as double,
        color: colors[index % colors.length],
      );
    }).toList();
  }

  /// Gera dados de exemplo para gráfico de redes
  static List<PieChartData> generateNetworksData() {
    final networks = [
      {'name': 'Ethereum', 'value': 35.4},
      {'name': 'Base', 'value': 22.1},
      {'name': 'Polygon', 'value': 18.7},
      {'name': 'Avalanche', 'value': 12.9},
      {'name': 'Arbitrum', 'value': 8.3},
      {'name': 'BSC', 'value': 2.6},
    ];

    final colors = [
      const Color(0xFF627EEA), // Ethereum blue
      const Color(0xFF0052FF), // Base blue
      const Color(0xFF8247E5), // Polygon purple
      const Color(0xFFE84142), // Avalanche red
      const Color(0xFF28A0F0), // Arbitrum blue
      const Color(0xFFF3BA2F), // BSC yellow
    ];

    return networks.asMap().entries.map((entry) {
      final index = entry.key;
      final network = entry.value;
      return PieChartData(
        label: network['name'] as String,
        value: network['value'] as double,
        percentage: network['value'] as double,
        color: colors[index % colors.length],
      );
    }).toList();
  }
}
