// lib/data/local/local_wallet_datasource.dart
// DataSource local da carteira – segue a mesma lógica do LocalTransactionsDataSource

import 'package:app_chain_view/models/token.dart';

class LocalWalletDataSource {
  final List<Token> _cache = [];

  // Retorna "página" do cache local
  Future<List<Token>> getPage({
    required int page,
    required int pageSize,
  }) async {
    final start = page * pageSize;
    final end = start + pageSize;
    if (_cache.isEmpty) return [];
    if (start >= _cache.length) return [];
    return _cache.sublist(start, end > _cache.length ? _cache.length : end);
  }

  Future<void> upsertAll(List<Token> items, {bool replace = false}) async {
    if (replace) {
      _cache
        ..clear()
        ..addAll(items);
      return;
    }
    // Insere/atualiza evitando duplicatas por symbol
    final existing = {for (final t in _cache) t.symbol};
    for (final t in items) {
      if (!existing.contains(t.symbol)) {
        _cache.add(t);
      } else {
        // substitui o existente pelo novo (mantém ordem de inserção)
        final index = _cache.indexWhere((x) => x.symbol == t.symbol);
        if (index != -1) _cache[index] = t;
      }
    }
    // Ordena por valor USD desc
    _cache.sort((a, b) => b.usdValue.compareTo(a.usdValue));
  }

  Future<void> clear() async => _cache.clear();
}
