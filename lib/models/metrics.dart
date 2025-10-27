// lib/models/metrics.dart
import 'package:app_chain_view/models/metrics/token_performance.dart';

import 'metrics/performance_point.dart';
import 'metrics/asset_slice.dart';

class Metrics {
  final String wallet;
  final double totalBalance;
  final double totalFees;
  final DateTime updatedAt;
  final List<PerformancePoint>? portfolioPerformance;
  final List<AssetSlice>? tokenSummary;
  final List<AssetSlice>? networkSummary;
  final List<TokenPerformance>? topPerformers;
  final List<TokenPerformance>? worstPerformers;

  Metrics({
    required this.wallet,
    required this.totalBalance,
    required this.totalFees,
    required this.updatedAt,
    this.portfolioPerformance,
    this.tokenSummary,
    this.networkSummary,
    this.topPerformers,
    this.worstPerformers,
  });

  Metrics copyWith({
    String? wallet,
    double? totalBalance,
    double? totalFees,
    DateTime? updatedAt,
    List<PerformancePoint>? portfolioPerformance,
    List<AssetSlice>? tokenSummary,
    List<AssetSlice>? networkSummary,
    List<TokenPerformance>? topPerformers,
    List<TokenPerformance>? worstPerformers,
  }) {
    return Metrics(
      wallet: wallet ?? this.wallet,
      totalBalance: totalBalance ?? this.totalBalance,
      totalFees: totalFees ?? this.totalFees,
      updatedAt: updatedAt ?? this.updatedAt,
      portfolioPerformance: portfolioPerformance ?? this.portfolioPerformance,
      tokenSummary: tokenSummary ?? this.tokenSummary,
      networkSummary: networkSummary ?? this.networkSummary,
      topPerformers: topPerformers ?? this.topPerformers,
      worstPerformers: worstPerformers ?? this.worstPerformers,
    );
  }

  Map<String, dynamic> toJson() => {
    'wallet': wallet,
    'totalBalance': totalBalance,
    'totalFees': totalFees,
    'updatedAt': updatedAt.toIso8601String(),
    'portfolioPerformance': portfolioPerformance
        ?.map((e) => e.toJson())
        .toList(),
    'tokenSummary': tokenSummary?.map((e) => e.toJson()).toList(),
    'networkSummary': networkSummary?.map((e) => e.toJson()).toList(),
    'topPerformers': topPerformers?.map((e) => e.toJson()).toList(),
    'worstPerformers': worstPerformers?.map((e) => e.toJson()).toList(),
  };

  factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
    wallet: (json['wallet']).toString(),
    totalBalance: (json['totalBalance'] as num).toDouble(),
    totalFees: (json['totalFees'] as num).toDouble(),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    portfolioPerformance: (json['portfolioPerformance'] as List?)
        ?.map((e) => PerformancePoint.fromJson(e as Map<String, dynamic>))
        .toList(),
    tokenSummary: (json['tokenSummary'] as List?)
        ?.map((e) => AssetSlice.fromJson(e as Map<String, dynamic>))
        .toList(),
    networkSummary: (json['networkSummary'] as List?)
        ?.map((e) => AssetSlice.fromJson(e as Map<String, dynamic>))
        .toList(),
    topPerformers: (json['topPerformers'] as List?)
        ?.map((e) => TokenPerformance.fromJson(e as Map<String, dynamic>))
        .toList(),
    worstPerformers: (json['worstPerformers'] as List?)
        ?.map((e) => TokenPerformance.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
