// lib/data/repositories/metrics_repository.dart
import 'package:app_chain_view/data/local/local_metrics_datasource.dart';
import 'package:app_chain_view/data/remote/remote_metrics_datasource.dart';
import 'package:app_chain_view/models/metrics.dart';
import 'package:app_chain_view/utils/sample_data_generator.dart';

class MetricsRepository {
  final LocalMetricsDataSource _local;
  final RemoteMetricsDataSource _remote;

  MetricsRepository({
    required LocalMetricsDataSource local,
    required RemoteMetricsDataSource remote,
  })  : _local = local,
        _remote = remote;

  Future<Metrics?> getLocalSnapshot() => _local.read();

  Future<Metrics> refreshFromRemote() async {
    final local = await _local.read();

    // Remoto mock (sem séries/sumários)
    final remote = await _remote.fetchMetrics();

    final data = remote.copyWith(
      totalBalance: SampleDataGenerator.generateTotalBalance(),
      portfolioPerformance: SampleDataGenerator.generateOneYearDailySeries(),
      tokenSummary: SampleDataGenerator.generateTokenSummary(),
      networkSummary: SampleDataGenerator.generateNetworkSummary(),
      topPerformers: SampleDataGenerator.generateTopPerformers(),
      worstPerformers: SampleDataGenerator.generateWorstPerformers(),
      totalFees: SampleDataGenerator.generateTotalFees(),
    );

    await _local.save(data);
    return data;
  }

  Future<void> clear() => _local.clear();
}
