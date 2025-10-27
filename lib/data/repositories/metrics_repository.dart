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

  Future<Metrics?> getLocalSnapshot({String? wallet}) =>
      _local.read(wallet: wallet);

  Future<Metrics> refreshFromRemote({String? wallet}) async {
    final remote = await _remote.fetchMetrics(wallet: wallet);

    final data = remote.copyWith(
      totalBalance: SampleDataGenerator.generateTotalBalance(),
      portfolioPerformance: SampleDataGenerator.generateOneYearDailySeries(),
      tokenSummary: SampleDataGenerator.generateTokenSummary(),
      networkSummary: SampleDataGenerator.generateNetworkSummary(),
      topPerformers: SampleDataGenerator.generateTopPerformers(),
      worstPerformers: SampleDataGenerator.generateWorstPerformers(),
      totalFees: SampleDataGenerator.generateTotalFees(),
      updatedAt: DateTime.now(), // usado para “Atualizado em”
    );

    await _local.save(data, wallet: wallet);
    return data;
  }

  Future<void> clear({String? wallet}) => _local.clear(wallet: wallet);
}
