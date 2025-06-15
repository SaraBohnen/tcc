// lib/views/metrics_screen.dart

import 'package:app_chain_view/components/top_performers_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/navigation_controller.dart';
import '../utils/constants.dart';
import '../utils/sample_data_generator.dart';
import '../components/total_balance_card.dart';
import '../components/period_filter_dropdown.dart';
import '../components/performance_line_chart.dart';
import '../components/chart_container.dart';
import '../components/pie_chart_component.dart';
import 'transactions_screen.dart';
import 'wallet_screen.dart';
import 'settings_screen.dart';

/// Conteúdo da aba "Métricas"
class MetricsTab extends StatefulWidget {
  const MetricsTab({Key? key}) : super(key: key);

  @override
  State<MetricsTab> createState() => _MetricsTabState();
}

class _MetricsTabState extends State<MetricsTab> {
  PeriodFilter _selectedFilter = PeriodFilter.last7Days;
  late List<PerformanceData> _chartData;

  @override
  void initState() {
    super.initState();
    _chartData = SampleDataGenerator.generatePerformanceData(_selectedFilter);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TotalBalanceCard(
              totalBalance: SampleDataGenerator.generateTotalBalance(),
            ),
            const SizedBox(height: 24),
            PeriodFilterDropdown(
              selectedFilter: _selectedFilter,
              onChanged: (newFilter) {
                if (newFilter == null) return;
                setState(() {
                  _selectedFilter = newFilter;
                  _chartData = SampleDataGenerator.generatePerformanceData(
                    _selectedFilter,
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            ChartContainer(
              title: 'Desempenho da carteira',
              chart: PerformanceLineChart(data: _chartData),
            ),
            const SizedBox(height: 24),

            // --- GRÁFICO 1: ATIVOS POR TOKEN ---
            ChartContainer(
              title: 'Resumo de tokens',
              chart: AssetPieChart(
                data: SampleDataGenerator.generatePreProcessedTokenData(),
              ),
            ),
            const SizedBox(height: 24),

            // --- GRÁFICO 2: ATIVOS POR REDE ---
            ChartContainer(
              title: 'Resumo de redes',
              chart: AssetPieChart(
                data: SampleDataGenerator.generatePreProcessedNetworkData(),
              ),
            ),
            const SizedBox(height: 24),

            // --- PAINEL: TOP 5 PERFORMERS ---
            ChartContainer(
              title: '5 tokens com melhor desempenho',
              chart: TopPerformersTable(
                data: SampleDataGenerator.generateTopPerformingTokens(),
              ),
            ),
            const SizedBox(height: 24),

            // --- PAINEL: WORST 5 PERFORMERS ---
            ChartContainer(
              title: '5 tokens com pior desempenho',
              chart: TopPerformersTable(
                data: SampleDataGenerator.generateWorstPerformingTokens(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget principal que contém AppBar, IndexedStack e BottomNavigationBar.
class MetricsScreen extends StatelessWidget {
  static const String routeName = '/';

  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationController>(
      create: (_) => NavigationController(),
      child: Consumer<NavigationController>(
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
              elevation: 0,
            ),
            body: IndexedStack(
              index: navController.currentIndex,
              children: const [
                MetricsTab(),
                TransactionsScreen(),
                WalletScreen(),
                SettingsScreen(),
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
