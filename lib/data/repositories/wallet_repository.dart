import 'package:app_chain_view/data/local/local_wallet_datasource.dart';
import 'package:app_chain_view/data/remote/remote_wallet_datasource.dart';
import 'package:app_chain_view/models/token.dart';

class WalletRepository {
  final LocalWalletDataSource local;
  final RemoteWalletDataSource remote;

  WalletRepository({required this.local, required this.remote});

  // Carrega página (sempre remoto primeiro, depois salva em cache local)
  Future<List<Token>> loadPage({
    required int page,
    required int pageSize,
    bool refresh = false,
  }) async {
    if (refresh && page == 0) {
      await local.clear();
    }

    final remoteItems = await remote.fetchPage(page: page, pageSize: pageSize);
    await local.upsertAll(remoteItems, replace: refresh && page == 0);

    // Retorna visão local da página solicitada
    return local.getPage(page: page, pageSize: pageSize);
  }
}
