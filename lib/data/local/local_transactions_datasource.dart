import 'package:app_chain_view/models/transaction.dart';

class LocalTransactionsDataSource {
  final List<Transaction> _cache = [];

  // Retorna "página" do cache local
  Future<List<Transaction>> getPage({
    required int page,
    required int pageSize,
  }) async {
    final start = page * pageSize;
    final end = start + pageSize;
    if (_cache.isEmpty) return [];
    if (start >= _cache.length) return [];
    return _cache.sublist(start, end > _cache.length ? _cache.length : end);
  }

  Future<void> upsertAll(List<Transaction> items, {bool replace = false}) async {
    if (replace) {
      _cache
        ..clear()
        ..addAll(items);
      return;
    }
    // Insere evitando duplicatas por id
    final existing = {for (final t in _cache) t.id};
    for (final t in items) {
      if (!existing.contains(t.id)) _cache.add(t);
    }
    // Ordena por data desc
    _cache.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> clear() async => _cache.clear();
}
