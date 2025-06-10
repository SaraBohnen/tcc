// lib/views/metrics_screen.dart

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

/// Conteúdo da aba "Métricas" (sem Scaffold interno!)
/// Coloca Painel "Total", Dropdown de filtro e gráfico.
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
            // ───────────────────────────────────────────────
            // PAINEL "TOTAL" - Usando componente
            // ───────────────────────────────────────────────
            TotalBalanceCard(
              totalBalance: SampleDataGenerator.generateTotalBalance(),
            ),

            const SizedBox(height: 24),

            // ───────────────────────────────────────────────
            // FILTRO DE PERÍODO - Usando componente
            // ───────────────────────────────────────────────
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

            // ───────────────────────────────────────────────
            // GRÁFICO DE DESEMPENHO - Usando componentes
            // ───────────────────────────────────────────────
            ChartContainer(
              title: 'Desempenho da Carteira',
              chart: PerformanceLineChart(data: _chartData),
            ),

            const SizedBox(height: 24),

            // ───────────────────────────────────────────────
            // GRÁFICO DE TOKENS - Usando componentes
            // ───────────────────────────────────────────────
            ChartContainer(
              title: 'Resumo de Tokens',
              height: 300,
              chart: CustomPieChart(
                data: SampleDataGenerator.generateTokensData(),
                radius: 80,
              ),
            ),

            const SizedBox(height: 24),

            // ───────────────────────────────────────────────
            // GRÁFICO DE REDES - Usando componentes
            // ───────────────────────────────────────────────
            ChartContainer(
              title: 'Resumo de Redes',
              height: 300,
              chart: CustomPieChart(
                data: SampleDataGenerator.generateNetworksData(),
                radius: 80,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Widget principal que contém AppBar, IndexedStack e BottomNavigationBar.
/// Não há Scaffold aninhados — apenas este único Scaffold.
class MetricsScreen extends StatelessWidget {
  static const String routeName = '/'; // rota raiz

  const MetricsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationController>(
      create: (_) => NavigationController(),
      child: Consumer<NavigationController>(
        builder: (context, navController, _) {
          // Lista de títulos dinâmicos para cada aba:
          final titles = [
            'Métricas',
            'Transações',
            'Carteira',
            'Configurações',
          ];
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            // AppBar único, com título baseado na aba selecionada
            appBar: AppBar(
              backgroundColor: AppColors.primaryWhite,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              title: Text(
                titles[navController.currentIndex],
                style: AppStyles.screenTitle,
              ),
              elevation: 0,
            ),
            // O body é apenas o IndexedStack
            body: IndexedStack(
              index: navController.currentIndex,
              children: const [
                MetricsTab(), // aba 0: conteúdo das Métricas
                TransactionsScreen(), // aba 1: Transações
                WalletScreen(), // aba 2: Carteira
                SettingsScreen(), // aba 3: Configurações
              ],
            ),
            // BottomNavigationBar abaixo
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
