// lib/views/transactions_screen.dart
// Tela de Histórico de Transações (conteúdo para o IndexedStack) – MVVM + paginação

import 'package:app_chain_view/components/transaction_list_item.dart';
import 'package:app_chain_view/data/local/local_transactions_datasource.dart';
import 'package:app_chain_view/data/remote/remote_transactions_datasource.dart';
import 'package:app_chain_view/data/repositories/transactions_repository.dart';
import 'package:app_chain_view/views/viewmodels/transactions_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransactionsViewModel>(
      create: (_) => TransactionsViewModel(
        TransactionsRepository(
          local: LocalTransactionsDataSource(),
          remote: RemoteTransactionsDataSource(),
        ),
      )..loadInitial(),
      child: const _TransactionsTab(),
    );
  }
}

class _TransactionsTab extends StatefulWidget {
  const _TransactionsTab();

  @override
  State<_TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<_TransactionsTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Scroll listener para "infinite scroll"
    _scrollController.addListener(() {
      final vm = context.read<TransactionsViewModel>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          vm.hasMore &&
          !vm.isLoading) {
        vm.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionsViewModel>();

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: vm.refresh,
        child: Container(
          color: AppColors.backgroundLight,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              // Estado de erro (não bloqueante)
              if (vm.error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: _ErrorBanner(message: vm.error!),
                  ),
                ),

              // Lista de transações
              if (vm.items.isEmpty && vm.isLoading)
                const SliverToBoxAdapter(child: _ShimmerList())
              else if (vm.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverList.builder(
                  itemCount: vm.items.length,
                  itemBuilder: (context, index) {
                    final tx = vm.items[index];
                    return Column(
                      children: [
                        TransactionListItem(
                          tx: tx,
                          onTap: () {
                            // TODO: navegar para detalhes (quando existir)
                          },
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  },
                ),

              // Rodapé de carregamento (paginações)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: vm.isLoading && vm.items.isNotEmpty
                        ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.6),
                    )
                        : (!vm.hasMore
                        ? const Text(
                      '— Fim do histórico —',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                        : const SizedBox.shrink()),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 12),
            Text(
              'Nenhuma transação encontrada',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.red),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () => context.read<TransactionsViewModel>().refresh(),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    // Placeholder simples – sem dependências externas
    return Column(
      children: List.generate(
        8,
            (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(20))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 180, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
