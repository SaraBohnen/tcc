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

  /// Gera dados de exemplo para os tokens, já processados.
  static List<AssetData> generatePreProcessedTokenData() {
    return [
      AssetData(name: 'Bitcoin', value: 4500.0, color: Colors.orange),
      AssetData(name: 'Ethereum', value: 3000.0, color: Colors.indigo),
      AssetData(name: 'USDC', value: 2000.0, color: Colors.green),
      AssetData(name: 'Solana', value: 1200.0, color: Colors.pinkAccent),
      AssetData(name: 'Cardano', value: 800.0, color: Colors.blue),
      AssetData(name: 'XRP', value: 500.0, color: Colors.teal),
      AssetData(name: 'Others', value: 750.0, color: Colors.blueGrey),
    ];
  }

  /// Gera dados de exemplo para as redes, já processados.
  static List<AssetData> generatePreProcessedNetworkData() {
    return [
      AssetData(name: 'Ethereum', value: 5500.0, color: Colors.indigo),
      AssetData(name: 'Bitcoin', value: 4500.0, color: Colors.orange),
      AssetData(name: 'BSC', value: 2500.0, color: Colors.amberAccent.shade700),
      AssetData(name: 'Solana', value: 1200.0, color: Colors.pinkAccent),
      AssetData(name: 'Polygon', value: 700.0, color: Colors.deepPurple),
      AssetData(name: 'Avalanche', value: 600.0, color: Colors.red.shade700),
      AssetData(name: 'Others', value: 750.0, color: Colors.blueGrey),
    ];
  }
}
