// lib/views/metrics_charts_manager_screen.dart
// Tela para gerenciar quais gráficos da tela de Métricas serão exibidos.
// Armazena preferências em SharedPreferences.
// Comentários em pt-BR.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class MetricsChartsManagerScreen extends StatefulWidget {
  static const routeName = '/metrics-charts-manager';

  const MetricsChartsManagerScreen({Key? key}) : super(key: key);

  @override
  State<MetricsChartsManagerScreen> createState() =>
      _MetricsChartsManagerScreenState();
}

class _MetricsChartsManagerScreenState
    extends State<MetricsChartsManagerScreen> {
  // 🔹 Chaves de preferência (use as mesmas depois na MetricsTab)
  static const _kShowTotalBalance = 'show_total_balance';
  static const _kShowPerformanceLine = 'show_performance_line';
  static const _kShowTokenPie = 'show_token_pie';
  static const _kShowNetworkPie = 'show_network_pie';
  static const _kShowTopBest = 'show_top_best';
  static const _kShowTopWorst = 'show_top_worst';
  static const _kShowFeesTotal = 'show_fees_total';

  bool _loading = true;

  // 🔹 Valores padrão (todos visíveis)
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
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _showTotalBalance = sp.getBool(_kShowTotalBalance) ?? true;
      _showPerformanceLine = sp.getBool(_kShowPerformanceLine) ?? true;
      _showTokenPie = sp.getBool(_kShowTokenPie) ?? true;
      _showNetworkPie = sp.getBool(_kShowNetworkPie) ?? true;
      _showTopBest = sp.getBool(_kShowTopBest) ?? true;
      _showTopWorst = sp.getBool(_kShowTopWorst) ?? true;
      _showFeesTotal = sp.getBool(_kShowFeesTotal) ?? true;
      _loading = false;
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(key, value);
    // 🔹 Feedback rápido ao usuário
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Preferência atualizada',
            textAlign: TextAlign.center,
            style: AppStyles.bodyText.copyWith(color: AppColors.primaryWhite),
          ),
          duration: const Duration(milliseconds: 900),
          backgroundColor: AppColors.accentBlue,
        ),
      );
    }
  }

  // 🔹 Selecionar todos
  Future<void> _selectAll() async {
    setState(() {
      _showTotalBalance = true;
      _showPerformanceLine = true;
      _showTokenPie = true;
      _showNetworkPie = true;
      _showTopBest = true;
      _showTopWorst = true;
      _showFeesTotal = true;
    });
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kShowTotalBalance, true);
    await sp.setBool(_kShowPerformanceLine, true);
    await sp.setBool(_kShowTokenPie, true);
    await sp.setBool(_kShowNetworkPie, true);
    await sp.setBool(_kShowTopBest, true);
    await sp.setBool(_kShowTopWorst, true);
    await sp.setBool(_kShowFeesTotal, true);
  }

  // 🔹 Limpar todos
  Future<void> _clearAll() async {
    setState(() {
      _showTotalBalance = false;
      _showPerformanceLine = false;
      _showTokenPie = false;
      _showNetworkPie = false;
      _showTopBest = false;
      _showTopWorst = false;
      _showFeesTotal = false;
    });
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kShowTotalBalance, false);
    await sp.setBool(_kShowPerformanceLine, false);
    await sp.setBool(_kShowTokenPie, false);
    await sp.setBool(_kShowNetworkPie, false);
    await sp.setBool(_kShowTopBest, false);
    await sp.setBool(_kShowTopWorst, false);
    await sp.setBool(_kShowFeesTotal, false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text('Gerenciar Gráficos', style: AppStyles.screenTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          // 🔹 Ações rápidas
          TextButton(
            onPressed: _selectAll,
            child: const Text('Marcar todos'),
          ),
          TextButton(
            onPressed: _clearAll,
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(label: 'Métricas Gerais'),

          SwitchListTile(
            title: const Text('Saldo Total (TotalBalanceCard)'),
            subtitle: const Text('Mostra o cartão com o saldo total'),
            value: _showTotalBalance,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showTotalBalance = v);
              _savePref(_kShowTotalBalance, v);
            },
          ),
          SwitchListTile(
            title: const Text('Desempenho da Carteira (Linha)'),
            subtitle: const Text('Exibe o gráfico de linha (PerformanceLineChart)'),
            value: _showPerformanceLine,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showPerformanceLine = v);
              _savePref(_kShowPerformanceLine, v);
            },
          ),

          const SizedBox(height: 16),
          const _SectionHeader(label: 'Distribuição de Ativos'),

          SwitchListTile(
            title: const Text('Resumo de Tokens (Pizza)'),
            subtitle: const Text('Exibe o gráfico de pizza por token'),
            value: _showTokenPie,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showTokenPie = v);
              _savePref(_kShowTokenPie, v);
            },
          ),
          SwitchListTile(
            title: const Text('Resumo de Redes (Pizza)'),
            subtitle: const Text('Exibe o gráfico de pizza por rede'),
            value: _showNetworkPie,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showNetworkPie = v);
              _savePref(_kShowNetworkPie, v);
            },
          ),

          const SizedBox(height: 16),
          const _SectionHeader(label: 'Ranking de Desempenho'),

          SwitchListTile(
            title: const Text('Top 5 Melhores'),
            subtitle: const Text('Tabela com melhores desempenhos'),
            value: _showTopBest,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showTopBest = v);
              _savePref(_kShowTopBest, v);
            },
          ),
          SwitchListTile(
            title: const Text('Top 5 Piores'),
            subtitle: const Text('Tabela com piores desempenhos'),
            value: _showTopWorst,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showTopWorst = v);
              _savePref(_kShowTopWorst, v);
            },
          ),

          const SizedBox(height: 16),
          const _SectionHeader(label: 'Custos'),

          SwitchListTile(
            title: const Text('Total de Taxas'),
            subtitle: const Text('Mostra o cartão com o total de taxas'),
            value: _showFeesTotal,
            activeColor: AppColors.accentBlue,
            onChanged: (v) {
              setState(() => _showFeesTotal = v);
              _savePref(_kShowFeesTotal, v);
            },
          ),

          const SizedBox(height: 24),
          Text(
            'As alterações são salvas automaticamente. Volte para a tela de Métricas para ver o resultado.',
            style: AppStyles.bodyText.copyWith(fontSize: 12, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// 🔹 Cabeçalho simples para seções (sem AppStyles.sectionTitle)
class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        label,
        style: AppStyles.bodyText.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
