// lib/views/metrics_screen.dart
// Ajustado para injetar Repository e suportar pull-to-refresh – comentários em PT-BR
import 'package:app_chain_view/components/top_performers_table.dart';
import 'package:app_chain_view/views/viewmodels/app_viewmodel.dart';
import 'package:app_chain_view/views/viewmodels/metrics_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../components/total_balance_card.dart';
import '../components/period_filter_dropdown.dart';
import '../components/performance_line_chart.dart';
import '../components/chart_container.dart';
import '../components/pie_chart_component.dart';
import 'transactions_screen.dart';
import 'wallet_screen.dart';
import 'settings_screen.dart';

// NOVOS imports para DI
import 'package:app_chain_view/data/local/local_metrics_datasource.dart';
import 'package:app_chain_view/data/remote/remote_metrics_datasource.dart';
import 'package:app_chain_view/data/repositories/metrics_repository.dart';

/// Conteúdo da aba "Métricas"
class MetricsTab extends StatelessWidget {
  const MetricsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MetricsViewModel>();

    // RefreshIndicator para puxar-para-atualizar
    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: vm.refresh, // força consulta no "remoto"
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // necessário p/ pull-to-refresh
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (vm.isRefreshing) const LinearProgressIndicator(),
              if (vm.updatedAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Atualizado em: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(vm.updatedAt!)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

              // --- SALDO TOTAL ---
              TotalBalanceCard(totalBalance: vm.totalBalance, title: "Total"),
              const SizedBox(height: 24),

              // --- FILTRO DE PERÍODO ---
              PeriodFilterDropdown(
                selectedFilter: vm.selectedFilter,
                onChanged: (newFilter) {
                  if (newFilter == null) return;
                  vm.updateFilter(newFilter);
                },
              ),
              const SizedBox(height: 16),

              // --- GRÁFICO DE LINHA ---
              ChartContainer(
                title: 'Desempenho da carteira',
                chart: PerformanceLineChart(data: vm.performanceData),
              ),
              const SizedBox(height: 24),

              // --- GRÁFICO 1: ATIVOS POR TOKEN ---
              ChartContainer(
                title: 'Resumo de tokens',
                chart: AssetPieChart(data: vm.tokenData),
              ),
              const SizedBox(height: 24),

              // --- GRÁFICO 2: ATIVOS POR REDE ---
              ChartContainer(
                title: 'Resumo de redes',
                chart: AssetPieChart(data: vm.networkData),
              ),
              const SizedBox(height: 24),

              // --- TOP 5 MELHORES ---
              ChartContainer(
                title: '5 tokens com melhor desempenho',
                chart: TopPerformersTable(data: vm.topPerformers),
              ),
              const SizedBox(height: 24),

              // --- TOP 5 PIORES ---
              ChartContainer(
                title: '5 tokens com pior desempenho',
                chart: TopPerformersTable(data: vm.worstPerformers),
              ),
              const SizedBox(height: 24),

              // --- TOTAL DE TAXAS ---
              TotalBalanceCard(
                totalBalance: vm.totalFees,
                title: "Total de Taxas",
              ),
              const SizedBox(height: 24),

              //--- FRASE E ÍCONE ---
              Column(
                children: const [
                  Icon(Icons.bar_chart, size: 58, color: Colors.grey),
                  Text(
                    'GERENCIAR GRÁFICOS',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              //--- IMAGEM FINAL ---
              Image.asset('assets/images/metrics.png', fit: BoxFit.contain),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget principal que contém AppBar, IndexedStack e BottomNavigationBar.
class MetricsScreen extends StatelessWidget {
  static const routeName = '/metrics';

  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppViewmodel>(
      create: (_) => AppViewmodel(),
      child: Consumer<AppViewmodel>(
        builder: (context, navController, _) {
          final titles = [
            'Métricas',
            'Transações',
            'Carteira',
            'Configurações',
          ];
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppColors.primaryWhite,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              title: Text(
                titles[navController.currentIndex],
                style: AppStyles.screenTitle,
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: IndexedStack(
              index: navController.currentIndex,
              children: [
                // Injeção do Repository + ViewModel (local-first)
                ChangeNotifierProvider<MetricsViewModel>(
                  create: (_) {
                    final repo = MetricsRepository(
                      local: LocalMetricsDataSource(),
                      remote: RemoteMetricsDataSource(),
                    );
                    return MetricsViewModel(repo)..loadAll();
                  },
                  child: const MetricsTab(),
                ),
                const TransactionsScreen(),
                const WalletScreen(),
                const SettingsScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: navController.currentIndex,
              backgroundColor: AppColors.primaryWhite,
              selectedItemColor: AppColors.navSelected,
              unselectedItemColor: AppColors.navUnselected,
              type: BottomNavigationBarType.fixed,
              onTap: (idx) => navController.setIndex(idx),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart),
                  label: 'Métricas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz),
                  label: 'Transações',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  label: 'Carteira',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Configurações',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
