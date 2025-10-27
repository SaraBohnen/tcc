// lib/views/metrics_screen.dart
// Lê o endereço salvo e carrega métricas; suporta pull-to-refresh,
// visibilidade de gráficos por SharedPreferences e combobox de carteiras.
// Comentários em pt-BR.

import 'package:app_chain_view/components/pie_chart_component.dart';
import 'package:app_chain_view/components/top_performers_table.dart';
import 'package:app_chain_view/views/viewmodels/app_viewmodel.dart';
import 'package:app_chain_view/views/viewmodels/metrics_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../components/total_balance_card.dart';
import '../components/period_filter_dropdown.dart';
import '../components/performance_line_chart.dart';
import '../components/chart_container.dart';
import 'transactions_screen.dart';
import 'wallet_screen.dart';
import 'settings_screen.dart';
import 'package:app_chain_view/data/local/local_metrics_datasource.dart';
import 'package:app_chain_view/data/remote/remote_metrics_datasource.dart';
import 'package:app_chain_view/data/repositories/metrics_repository.dart';

class MetricsTab extends StatefulWidget {
  const MetricsTab({Key? key}) : super(key: key);

  @override
  State<MetricsTab> createState() => _MetricsTabState();
}

class _MetricsTabState extends State<MetricsTab> {
  // 🔹 Chaves usadas também na tela de gerenciamento (devem ser idênticas)
  static const _kShowTotalBalance = 'show_total_balance';
  static const _kShowPerformanceLine = 'show_performance_line';
  static const _kShowTokenPie = 'show_token_pie';
  static const _kShowNetworkPie = 'show_network_pie';
  static const _kShowTopBest = 'show_top_best';
  static const _kShowTopWorst = 'show_top_worst';
  static const _kShowFeesTotal = 'show_fees_total';

  bool _prefsLoading = true;

  bool _showTotalBalance = true;
  bool _showPerformanceLine = true;
  bool _showTokenPie = true;
  bool _showNetworkPie = true;
  bool _showTopBest = true;
  bool _showTopWorst = true;
  bool _showFeesTotal = true;

  @override
  void initState() {
    super.initState();
    _loadVisibilityPrefs();
  }

  Future<void> _loadVisibilityPrefs() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _showTotalBalance = sp.getBool(_kShowTotalBalance) ?? true;
      _showPerformanceLine = sp.getBool(_kShowPerformanceLine) ?? true;
      _showTokenPie = sp.getBool(_kShowTokenPie) ?? true;
      _showNetworkPie = sp.getBool(_kShowNetworkPie) ?? true;
      _showTopBest = sp.getBool(_kShowTopBest) ?? true;
      _showTopWorst = sp.getBool(_kShowTopWorst) ?? true;
      _showFeesTotal = sp.getBool(_kShowFeesTotal) ?? true;
      _prefsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MetricsViewModel>();
    final nav = context.read<AppViewmodel>();

    // 🔹 Ações de navegação por toque
    void goToWallet() => nav.setIndex(2);
    void goToTransactions() => nav.setIndex(1);

    if (_prefsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        // 🔹 Atualiza dados e re-lê preferências de visibilidade
        onRefresh: () async {
          await vm.refresh();
          await _loadVisibilityPrefs();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (vm.isRefreshing) const LinearProgressIndicator(),

              // --- SELETOR DE CARTEIRA (ComboBox) ---
              FutureBuilder<List<String>>(
                future: _loadWalletsFromPrefs(),
                builder: (context, snap) {
                  final wallets = (snap.data ?? const <String>[]);
                  if (wallets.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Nenhuma carteira cadastrada. Adicione em Configurações.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  }

                  // Valor atual do VM ou o primeiro da lista
                  final current = (vm.currentWallet?.trim().isNotEmpty ?? false)
                      ? vm.currentWallet!.trim()
                      : wallets.first;

                  // Inicializa VM na 1ª renderização (sem wallet definida)
                  if (vm.currentWallet == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      vm.setCurrentWallet(current);
                      vm.loadAll(); // local-first + remoto
                    });
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: DropdownButtonFormField<String>(
                      value: current,
                      decoration: const InputDecoration(
                        labelText: 'Carteira',
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      isExpanded: true,
                      items: wallets
                          .map(
                            (w) => DropdownMenuItem(
                          value: w,
                          child: Text(
                            w,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (newWallet) async {
                        if (newWallet == null || newWallet.trim().isEmpty) return;
                        vm.setCurrentWallet(newWallet);
                        await vm.loadAll(); // troca de carteira → recarrega
                      },
                    ),
                  );
                },
              ),

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
              if (_showTotalBalance) ...[
                GestureDetector(
                  onTap: goToWallet, // toque leva para Carteira
                  child: TotalBalanceCard(
                    totalBalance: vm.totalBalance,
                    title: "Total",
                  ),
                ),
                const SizedBox(height: 24),
              ],

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
              if (_showPerformanceLine) ...[
                ChartContainer(
                  title: 'Desempenho da carteira',
                  chart: PerformanceLineChart(data: vm.performanceData),
                ),
                const SizedBox(height: 24),
              ],

              // --- GRÁFICO 1: ATIVOS POR TOKEN ---
              if (_showTokenPie) ...[
                ChartContainer(
                  title: 'Resumo de tokens',
                  chart: AssetPieChart(
                    data: vm.tokenData,
                    onTap: goToWallet, // toque leva para Carteira
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // --- GRÁFICO 2: ATIVOS POR REDE ---
              if (_showNetworkPie) ...[
                ChartContainer(
                  title: 'Resumo de redes',
                  chart: AssetPieChart(
                    data: vm.networkData,
                    onTap: goToWallet, // toque leva para Carteira
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // --- TOP 5 MELHORES ---
              if (_showTopBest) ...[
                ChartContainer(
                  title: '5 tokens com melhor desempenho',
                  chart: TopPerformersTable(data: vm.topPerformers),
                ),
                const SizedBox(height: 24),
              ],

              // --- TOP 5 PIORES ---
              if (_showTopWorst) ...[
                ChartContainer(
                  title: '5 tokens com pior desempenho',
                  chart: TopPerformersTable(data: vm.worstPerformers),
                ),
                const SizedBox(height: 24),
              ],

              // --- TOTAL DE TAXAS ---
              if (_showFeesTotal) ...[
                GestureDetector(
                  onTap: goToTransactions, // toque leva para Transações
                  child: TotalBalanceCard(
                    totalBalance: vm.totalFees,
                    title: "Total de Taxas",
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // --- CARTEIRA VINCULADA (informativo) ---
              if (vm.currentWallet?.isNotEmpty == true)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Text(
                    'Carteira vinculada: ${vm.currentWallet}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

              // --- Acesso ao gerenciador de gráficos ---
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/metrics-charts-manager');
                },
                child: Column(
                  children: const [
                    Icon(Icons.bar_chart, size: 58, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'GERENCIAR GRÁFICOS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Image.asset('assets/images/metrics.png', fit: BoxFit.contain),
            ],
          ),
        ),
      ),
    );
  }

  /// Lê lista de carteiras do SharedPreferences.
  /// - Lê `wallets` (StringList) e agrega `walletAddress` (última).
  /// - Normaliza e remove duplicatas (case-insensitive).
  Future<List<String>> _loadWalletsFromPrefs() async {
    final sp = await SharedPreferences.getInstance();

    final list = (sp.getStringList('wallets') ?? const <String>[])
        .map((w) => w.trim())
        .where((w) => w.isNotEmpty)
        .toList();

    final single = sp.getString('walletAddress')?.trim();
    if (single != null && single.isNotEmpty) {
      final exists = list.any((w) => w.toLowerCase() == single.toLowerCase());
      if (!exists) list.add(single);
    }

    final seen = <String>{};
    final deduped = <String>[];
    for (final w in list) {
      final key = w.toLowerCase();
      if (seen.add(key)) deduped.add(w);
    }

    return deduped;
  }
}

class MetricsScreen extends StatefulWidget {
  static const routeName = '/metrics';

  const MetricsScreen({Key? key}) : super(key: key);

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  String? wallet;
  bool _loadingWallet = true;

  @override
  void initState() {
    super.initState();
    _loadWallet();
  }

  Future<void> _loadWallet() async {
    final sp = await SharedPreferences.getInstance();
    // Mantém compatibilidade com a primeira carteira salva
    final addr = sp.getString('walletAddress')?.trim();
    setState(() {
      wallet = addr;
      _loadingWallet = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingWallet) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          return ChangeNotifierProvider<MetricsViewModel>(
            // Injeção do Repository + ViewModel (local-first e wallet-aware)
            create: (_) {
              final repo = MetricsRepository(
                local: LocalMetricsDataSource(),
                remote: RemoteMetricsDataSource(),
              );
              final vm = MetricsViewModel(repo);
              vm.setCurrentWallet(wallet); // carteira inicial, se houver
              vm.loadAll();                 // carrega dados para a carteira
              return vm;
            },
            child: Scaffold(
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
            ),
          );
        },
      ),
    );
  }
}
