// lib/views/viewmodels/metrics_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:app_chain_view/data/repositories/metrics_repository.dart';
import 'package:app_chain_view/models/metrics.dart';
import 'package:app_chain_view/models/metrics/performance_point.dart';
import 'package:app_chain_view/models/metrics/token_performance.dart';
import 'package:app_chain_view/models/metrics/asset_slice.dart';
import 'package:app_chain_view/components/performance_line_chart.dart';
import 'package:app_chain_view/components/period_filter_dropdown.dart';
import 'package:app_chain_view/components/top_performers_table.dart'; // para TokenPerformanceData

class MetricsViewModel extends ChangeNotifier {
  final MetricsRepository _repo;
  MetricsViewModel(this._repo);

  Metrics? _snapshot;

  double get totalBalance => _snapshot?.totalBalance ?? 0.0;
  double get totalFees => _snapshot?.totalFees ?? 0.0;
  DateTime? get updatedAt => _snapshot?.updatedAt;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  PeriodFilter _selectedFilter = PeriodFilter.last7Days;
  PeriodFilter get selectedFilter => _selectedFilter;

  // Série filtrada para o gráfico de linha
  List<PerformanceData> get performanceData {
    final series =
        _snapshot?.portfolioPerformance ?? const <PerformancePoint>[];
    if (series.isEmpty) return const [];
    final now = DateTime.now();
    DateTime cutoff;
    switch (_selectedFilter) {
      case PeriodFilter.last7Days:
        cutoff = now.subtract(const Duration(days: 6));
        break;
      case PeriodFilter.last1Month:
        cutoff = now.subtract(const Duration(days: 30));
        break;
      case PeriodFilter.last3Months:
        cutoff = now.subtract(const Duration(days: 90));
        break;
      case PeriodFilter.last1Year:
        cutoff = now.subtract(const Duration(days: 365));
        break;
    }
    final filtered = series.where((p) => !p.date.isBefore(cutoff)).toList();
    return filtered.map((p) => PerformanceData(p.date, p.value)).toList();
  }

  // Dados para os gráficos de pizza
  List<AssetSlice> get tokenData =>
      _snapshot?.tokenSummary ?? const <AssetSlice>[];
  List<AssetSlice> get networkData =>
      _snapshot?.networkSummary ?? const <AssetSlice>[];

  // Adaptadores para a tabela Top/Worst (converte para TokenPerformanceData do componente)
  List<TokenPerformanceData> get topPerformers {
    final list = _snapshot?.topPerformers ?? const <TokenPerformance>[];
    return list
        .map(
          (e) => TokenPerformanceData(
            name: e.name,
            price: e.price,
            sevenDayChange: e.sevenDayChange,
          ),
        )
        .toList();
  }

  List<TokenPerformanceData> get worstPerformers {
    final list = _snapshot?.worstPerformers ?? const <TokenPerformance>[];
    return list
        .map(
          (e) => TokenPerformanceData(
            name: e.name,
            price: e.price,
            sevenDayChange: e.sevenDayChange,
          ),
        )
        .toList();
  }

  /// carrega os dados
  Future<void> loadAll() async {
    final local = await _repo.getLocalSnapshot();
    if (local != null) {
      _snapshot = local;
      notifyListeners();
    }
    await refresh();
  }

  /// atualiza com dados mais recentes do repositório remoto
  Future<void> refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    try {
      final fresh = await _repo.refreshFromRemote();
      _snapshot = fresh;
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void updateFilter(PeriodFilter filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
