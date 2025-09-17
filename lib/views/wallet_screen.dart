import 'package:app_chain_view/views/viewmodels/wallet_viewmodel.dart';
import 'package:app_chain_view/data/repositories/wallet_repository.dart';
import 'package:app_chain_view/data/local/local_wallet_datasource.dart';
import 'package:app_chain_view/data/remote/remote_wallet_datasource.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WalletViewModel>(
      // Cria o ViewModel com o Repository (MVVM) – injeta local/remote
      create: (_) => WalletViewModel(
        WalletRepository(
          local: LocalWalletDataSource(),
          remote: RemoteWalletDataSource(),
        ),
      )..loadTokens(),
      child: const _WalletContent(),
    );
  }
}

class _WalletContent extends StatelessWidget {
  const _WalletContent();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WalletViewModel>();
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: vm.loadTokens,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // --- Tabela de Tokens ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "TOKEN/QUANTIDADE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("PREÇO", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "VALOR USD",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.tokens.length,
                itemBuilder: (context, index) {
                  final token = vm.tokens[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Token + Quantidade
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage(token.iconPath),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  token.quantity.toStringAsFixed(4),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  token.symbol,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Preço
                        Text(formatter.format(token.price)),
                        // Valor em USD
                        Text(
                          formatter.format(token.usdValue),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
