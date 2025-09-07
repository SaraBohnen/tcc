import 'package:flutter/foundation.dart';
import '../../utils/sample_data_generator.dart';
import '../../components/performance_line_chart.dart';
import '../../components/period_filter_dropdown.dart';
import '../../components/pie_chart_component.dart';
import '../../components/top_performers_table.dart';

/// ViewModel para a tela de Métricas
class MetricsViewModel extends ChangeNotifier {
  // --- ESTADOS ---
  double _totalBalance = 0.0;
  double get totalBalance => _totalBalance;

  double _totalFees = 0.0;
  double get totalFees => _totalFees;

  PeriodFilter _selectedFilter = PeriodFilter.last7Days;
  PeriodFilter get selectedFilter => _selectedFilter;

  List<PerformanceData> _performanceData = [];
  List<PerformanceData> get performanceData => _performanceData;

  List<AssetData> _tokenData = [];
  List<AssetData> get tokenData => _tokenData;

  List<AssetData> _networkData = [];
  List<AssetData> get networkData => _networkData;

  List<TokenPerformanceData> _topPerformers = [];
  List<TokenPerformanceData> get topPerformers => _topPerformers;

  List<TokenPerformanceData> _worstPerformers = [];
  List<TokenPerformanceData> get worstPerformers => _worstPerformers;

  // --- MÉTODOS DE CARGA ---
  //esse metódo carrega os dados toda vez que abrir a tela
  Future<void> loadAll() async {
    loadTotalBalance();
    loadTotalFees();
    loadPerformanceData();
    loadTokenData();
    loadNetworkData();
    loadTopPerformers();
    loadWorstPerformers();
  }

  void loadTotalBalance() {
    _totalBalance = SampleDataGenerator.generateTotalBalance();
    notifyListeners();
  }

  void loadTotalFees() {
    _totalFees = SampleDataGenerator.generateTotalFees();
    notifyListeners();
  }

  void loadPerformanceData() {
    _performanceData = SampleDataGenerator.generatePerformanceData(_selectedFilter);
    notifyListeners();
  }

  void loadTokenData() {
    _tokenData = SampleDataGenerator.generatePreProcessedTokenData();
    notifyListeners();
  }

  void loadNetworkData() {
    _networkData = SampleDataGenerator.generatePreProcessedNetworkData();
    notifyListeners();
  }

  void loadTopPerformers() {
    _topPerformers = SampleDataGenerator.generateTopPerformingTokens();
    notifyListeners();
  }

  void loadWorstPerformers() {
    _worstPerformers = SampleDataGenerator.generateWorstPerformingTokens();
    notifyListeners();
  }

  // --- AÇÃO DO FILTRO ---
  void updateFilter(PeriodFilter filter) {
    _selectedFilter = filter;
    loadPerformanceData();
  }
}
