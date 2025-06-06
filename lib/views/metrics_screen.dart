// lib/views/metrics_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../controllers/navigation_controller.dart';
import '../utils/constants.dart';
import 'transactions_screen.dart';
import 'wallet_screen.dart';
import 'settings_screen.dart';

/// Modelo para cada ponto de desempenho (data + valor)
class PerformanceData {
  final DateTime date;
  final double value;
  PerformanceData(this.date, this.value);
}

/// Enum para os períodos de filtro
enum PeriodFilter { last7Days, last1Month, last3Months, last1Year }

/// Extensão que fornece o rótulo legível para cada filtro
extension PeriodFilterExtension on PeriodFilter {
  String get label {
    switch (this) {
      case PeriodFilter.last7Days:
        return '7 dias';
      case PeriodFilter.last1Month:
        return '1 mês';
      case PeriodFilter.last3Months:
        return '3 meses';
      case PeriodFilter.last1Year:
        return '1 ano';
    }
  }
}

/// Widget que exibe o gráfico de linha usando FL Chart,
/// recebendo uma lista de [PerformanceData].
class PerformanceLineChart extends StatelessWidget {
  final List<PerformanceData> data;
  const PerformanceLineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Sem dados para exibir'));
    }

    // Base para converter datas em dias desde o início
    final baseDate = data.first.date;
    final spots =
        data.map((pd) {
          final x = pd.date.difference(baseDate).inDays.toDouble();
          return FlSpot(x, pd.value);
        }).toList();

    // Encontrar minY e maxY
    final values = data.map((e) => e.value).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.length) return const SizedBox();
                final date = data[index].date;
                final label = DateFormat('dd/MM').format(date);
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
              interval: (maxY - minY) / 4,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: AppColors.textSecondary),
            bottom: BorderSide(color: AppColors.textSecondary),
            right: BorderSide(color: Colors.transparent),
            top: BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: AppColors.accentBlue,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.accentBlue.withOpacity(0.2),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = data[spot.spotIndex].date;
                final val = data[spot.spotIndex].value;
                final formattedDate = DateFormat('dd/MM/yyyy').format(date);
                return LineTooltipItem(
                  '$formattedDate\nR\$ ${val.toStringAsFixed(2)}',
                  const TextStyle(color: AppColors.textPrimary, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

/// Conteúdo da aba “Métricas” (sem Scaffold interno!)
/// Coloca Painel “Total”, Dropdown de filtro e gráfico.
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
    _chartData = _generateSampleData(_selectedFilter);
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
            // PAINEL “TOTAL”
            // ───────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total', style: AppStyles.screenTitle),
                  SizedBox(height: 8),
                  Text(
                    'R\$ 0,00', // placeholder; substituir por valor real
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ───────────────────────────────────────────────
            // FILTRO DE PERÍODO
            // ───────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Período:',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<PeriodFilter>(
                  value: _selectedFilter,
                  items:
                      PeriodFilter.values.map((pf) {
                        return DropdownMenuItem(
                          value: pf,
                          child: Text(pf.label),
                        );
                      }).toList(),
                  onChanged: (newFilter) {
                    if (newFilter == null) return;
                    setState(() {
                      _selectedFilter = newFilter;
                      _chartData = _generateSampleData(_selectedFilter);
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ───────────────────────────────────────────────
            // PAINEL “DESEMPENHO DA CARTEIRA” (sem height fixo)
            // ───────────────────────────────────────────────
            Container(
              // REMOVIDO: height: 260,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Desempenho da Carteira',
                      style: AppStyles.screenTitle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200, // altura fixa apenas para o gráfico em si
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PerformanceLineChart(data: _chartData),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Gera dados de exemplo conforme o filtro selecionado.
  /// Quando tiver o backend pronto, troque esta função
  /// por chamada real ao banco de dados.
  List<PerformanceData> _generateSampleData(PeriodFilter filter) {
    final now = DateTime.now();
    late DateTime startDate;
    late int pointCount;

    switch (filter) {
      case PeriodFilter.last7Days:
        startDate = now.subtract(const Duration(days: 6));
        pointCount = 7;
        break;
      case PeriodFilter.last1Month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        pointCount = 30;
        break;
      case PeriodFilter.last3Months:
        startDate = DateTime(now.year, now.month - 3, now.day);
        pointCount = 45;
        break;
      case PeriodFilter.last1Year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        pointCount = 52;
        break;
    }

    final List<PerformanceData> data = [];
    for (int i = 0; i < pointCount; i++) {
      late DateTime pointDate;
      switch (filter) {
        case PeriodFilter.last7Days:
          pointDate = startDate.add(Duration(days: i));
          break;
        case PeriodFilter.last1Month:
          pointDate = startDate.add(Duration(days: i));
          break;
        case PeriodFilter.last3Months:
          final totalDays = now.difference(startDate).inDays;
          final step = totalDays / (pointCount - 1);
          pointDate = startDate.add(Duration(days: (step * i).round()));
          break;
        case PeriodFilter.last1Year:
          final totalDays = now.difference(startDate).inDays;
          final step = totalDays / (pointCount - 1);
          pointDate = startDate.add(Duration(days: (step * i).round()));
          break;
      }
      // Para fins didáticos, geramos um valor crescente linear
      final baseValue = 1000.0;
      final variation = (i * 20).toDouble();
      data.add(PerformanceData(pointDate, baseValue + variation));
    }

    return data;
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
