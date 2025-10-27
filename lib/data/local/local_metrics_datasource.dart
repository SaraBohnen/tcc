import 'package:app_chain_view/models/metrics.dart';
import 'package:app_chain_view/services/local_secure_storage.dart';

class LocalMetricsDataSource {
  static const _kDefaultKey = 'metrics_snapshot_default';

  String _keyFor(String? wallet) {
    final w = wallet?.trim();
    if (w == null || w.isEmpty) return _kDefaultKey;
    return 'metrics_snapshot_${w.toLowerCase()}';
  }

  Future<void> save(Metrics snapshot, {String? wallet}) async {
    await LocalSecureStorage.saveObject(_keyFor(wallet), snapshot.toJson());
  }

  Future<Metrics?> read({String? wallet}) async {
    return LocalSecureStorage.readObject<Metrics>(
      _keyFor(wallet),
          (json) => Metrics.fromJson(json),
    );
  }

  Future<void> clear({String? wallet}) =>
      LocalSecureStorage.delete(_keyFor(wallet));
}
