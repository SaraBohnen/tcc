import 'package:app_chain_view/data/local/local_transactions_datasource.dart';
import 'package:app_chain_view/data/remote/remote_transactions_datasource.dart';
import 'package:app_chain_view/models/transaction.dart';

class TransactionsRepository {
  final LocalTransactionsDataSource local;
  final RemoteTransactionsDataSource remote;

  TransactionsRepository({required this.local, required this.remote});

  // Carrega página (sempre do remoto para manter atual) e atualiza cache
  Future<List<Transaction>> loadPage({
    required int page,
    required int pageSize,
    bool refresh = false,
  }) async {
    if (refresh && page == 0) {
      await local.clear();
    }
    final remoteItems = await remote.fetchPage(page: page, pageSize: pageSize);
    await local.upsertAll(remoteItems, replace: refresh && page == 0);
    // Retorna visão local da página solicitada (ordenada)
    return local.getPage(page: page, pageSize: pageSize);
  }
}
