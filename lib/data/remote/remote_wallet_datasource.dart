// lib/data/remote/remote_wallet_datasource.dart
// DataSource remoto da carteira – delega geração para o SampleDataGenerator

import 'package:app_chain_view/models/token.dart';
import 'package:app_chain_view/utils/sample_data_generator.dart';

class RemoteWalletDataSource {
  Future<List<Token>> fetchPage({
    required int page,
    required int pageSize,
  }) async {
    // Simula latência de rede
    await Future.delayed(const Duration(milliseconds: 600));

    // **Delegação**: geração centralizada no SampleDataGenerator
    return SampleDataGenerator.generateTokensPage(
      page: page,
      pageSize: pageSize,
    );
  }
}
