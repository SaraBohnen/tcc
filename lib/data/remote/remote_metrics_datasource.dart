import '../../models/metrics.dart';

class RemoteMetricsDataSource {
  Future<Metrics> fetchMetrics({String? wallet}) async {
    // Simula latência
    await Future.delayed(const Duration(milliseconds: 600));

    return Metrics(
      wallet: wallet?.trim() ?? "",
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
