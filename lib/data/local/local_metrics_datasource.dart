  // lib/data/local/local_metrics_datasource.dart
  // DataSource local (secure storage)
  import 'package:app_chain_view/models/metrics.dart';
  import 'package:app_chain_view/services/local_secure_storage.dart';

  class LocalMetricsDataSource {
    static const _kMetricsKey = 'metrics_snapshot';

    Future<void> save(Metrics snapshot) async {
      await LocalSecureStorage.saveObject(_kMetricsKey, snapshot.toJson());
    }

    Future<Metrics?> read() async {
      return LocalSecureStorage.readObject<Metrics>(
        _kMetricsKey,
            (json) => Metrics.fromJson(json),
      );
    }

    Future<void> clear() => LocalSecureStorage.delete(_kMetricsKey);
  }
