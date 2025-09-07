// lib/data/remote/remote_transactions_datasource.dart
// Remove a geração local e delega para o SampleDataGenerator – comentários em PT-BR

import 'package:app_chain_view/models/transaction.dart';
import 'package:app_chain_view/utils/sample_data_generator.dart';

class RemoteTransactionsDataSource {
  Future<List<Transaction>> fetchPage({
    required int page,
    required int pageSize,
  }) async {
    // Simula latência de rede
    await Future.delayed(const Duration(milliseconds: 600));

    // **Delegação**: geração centralizada no SampleDataGenerator
    return SampleDataGenerator.generateTransactionsPage(
      page: page,
      pageSize: pageSize,
    );
  }
}
