// lib/data/remote/remote_metrics_datasource.dart
import '../../models/metrics.dart';

class RemoteMetricsDataSource {
  Future<Metrics> fetchMetrics() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return Metrics(
      totalBalance: 0,
      totalFees: 0,
      updatedAt: DateTime.now(),
      portfolioPerformance: null,
      tokenSummary: null,
      networkSummary: null,
      topPerformers: null,
      worstPerformers: null,

    );
  }
}
