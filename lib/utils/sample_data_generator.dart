// lib/utils/sample_data_generator.dart
// Geração de dados de exemplo (sem dependências de UI)

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_chain_view/models/metrics/performance_point.dart';
import 'package:app_chain_view/models/metrics/asset_slice.dart';
import 'package:app_chain_view/models/metrics/token_performance.dart';

class SampleDataGenerator {
  static final _random = Random();

  /// Gera um saldo total aleatório
  static double generateTotalBalance() {
    return 1000 + _random.nextDouble() * 9000;
  }

  /// Gera taxas aleatórias
  static double generateTotalFees() {
    return 0.01 + _random.nextDouble() * 1.99;
  }

  /// Série diária de 1 ano (365 dias) – random walk
  static List<PerformancePoint> generateOneYearDailySeries({
    double startBase = 1200.0,
    double dailyVolatility = 0.02,
    int days = 365,
  }) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days - 1));
    final List<PerformancePoint> series = [];

    double value = startBase + _random.nextDouble() * 200;
    for (int i = 0; i < days; i++) {
      final drift = (_random.nextDouble() * 2 - 1) * dailyVolatility;
      value = (value * (1 + drift)).clamp(200.0, 100000.0);
      final pointDate = startDate.add(Duration(days: i));
      series.add(PerformancePoint(pointDate, value));
    }
    return series;
  }

  /// Tokens (cores fixas, valores aleatórios)
  static List<AssetSlice> generateTokenSummary() {
    return [
      AssetSlice(name: 'Bitcoin',  value: 2000 + _random.nextDouble() * 8000, color: Colors.orange),
      AssetSlice(name: 'Ethereum', value: 1500 + _random.nextDouble() * 6000, color: Colors.indigo),
      AssetSlice(name: 'USDC',     value: 1000 + _random.nextDouble() * 3000, color: Colors.green),
      AssetSlice(name: 'Solana',   value: 500  + _random.nextDouble() * 2000, color: Colors.pinkAccent),
      AssetSlice(name: 'Cardano',  value: 300  + _random.nextDouble() * 1200, color: Colors.blue),
      AssetSlice(name: 'XRP',      value: 200  + _random.nextDouble() * 800,  color: Colors.teal),
      AssetSlice(name: 'Others',   value: 200  + _random.nextDouble() * 1500, color: Colors.blueGrey),
    ];
  }

  /// Redes (cores fixas, valores aleatórios)
  static List<AssetSlice> generateNetworkSummary() {
    return [
      AssetSlice(name: 'Ethereum', value: 2000 + _random.nextDouble() * 8000, color: Colors.indigo),
      AssetSlice(name: 'Bitcoin',  value: 2000 + _random.nextDouble() * 7000, color: Colors.orange),
      AssetSlice(name: 'BSC',      value: 1000 + _random.nextDouble() * 4000, color: Colors.amberAccent.shade700),
      AssetSlice(name: 'Solana',   value: 500  + _random.nextDouble() * 2000, color: Colors.pinkAccent),
      AssetSlice(name: 'Polygon',  value: 300  + _random.nextDouble() * 1500, color: Colors.deepPurple),
      AssetSlice(name: 'Avalanche',value: 300  + _random.nextDouble() * 1500, color: Colors.red.shade700),
      AssetSlice(name: 'Others',   value: 200  + _random.nextDouble() * 1500, color: Colors.blueGrey),
    ];
  }

  /// Gera Top 5 com variações positivas
  static List<TokenPerformance> generateTopPerformers({int count = 5}) {
    final names = ['Solana','Avalanche','Toncoin','Chainlink','Bitcoin','Ethereum','Polkadot','Near'];
    final list = List<TokenPerformance>.generate(names.length, (i) {
      final price = 1 + _random.nextDouble() * 70000;
      final change = 5 + _random.nextDouble() * 25; // 5%..30%
      return TokenPerformance(name: names[i], price: double.parse(price.toStringAsFixed(2)), sevenDayChange: double.parse(change.toStringAsFixed(1)));
    });
    list.sort((a,b) => b.sevenDayChange.compareTo(a.sevenDayChange));
    return list.take(count).toList();
  }

  /// Gera Worst 5 com variações negativas
  static List<TokenPerformance> generateWorstPerformers({int count = 5}) {
    final names = ['Chainlink','Starknet','Celestia','Uniswap','Ethereum','Arbitrum','Sui','Aptos'];
    final list = List<TokenPerformance>.generate(names.length, (i) {
      final price = 1 + _random.nextDouble() * 4000;
      final change = -(5 + _random.nextDouble() * 20); // -5%..-25%
      return TokenPerformance(name: names[i], price: double.parse(price.toStringAsFixed(2)), sevenDayChange: double.parse(change.toStringAsFixed(1)));
    });
    list.sort((a,b) => a.sevenDayChange.compareTo(b.sevenDayChange));
    return list.take(count).toList();
  }
}
