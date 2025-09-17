// lib/views/viewmodels/wallet_viewmodel.dart
// ViewModel da Carteira – mesmo padrão do TransactionsViewModel (paginação, refresh, estados)

import 'package:flutter/foundation.dart';
import 'package:app_chain_view/models/token.dart';
import 'package:app_chain_view/data/repositories/wallet_repository.dart';

class WalletViewModel extends ChangeNotifier {
  final WalletRepository repo;
  final int pageSize;

  WalletViewModel(this.repo, {this.pageSize = 20});

  final List<Token> _tokens = [];
  List<Token> get tokens => List.unmodifiable(_tokens);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _error;
  String? get error => _error;

  int _page = 0;

  // Conveniência para a UI atual (WalletScreen chama loadTokens)
  Future<void> loadTokens() => refresh();

  // Carga inicial
  Future<void> loadInitial() async {
    if (_isLoading) return;
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      _page = 0;
      final data = await repo.loadPage(
        page: _page,
        pageSize: pageSize,
        refresh: true,
      );
      _tokens
        ..clear()
        ..addAll(data);
      _hasMore = data.length == pageSize;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pull-to-refresh
  Future<void> refresh() async {
    if (_isRefreshing) return;
    _error = null;
    _isRefreshing = true;
    notifyListeners();
    try {
      _page = 0;
      final data = await repo.loadPage(
        page: _page,
        pageSize: pageSize,
        refresh: true,
      );
      _tokens
        ..clear()
        ..addAll(data);
      _hasMore = data.length == pageSize;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Paginação (se aplicável)
  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _page += 1;
      final data = await repo.loadPage(page: _page, pageSize: pageSize);
      _tokens.addAll(data);
      if (data.length < pageSize) _hasMore = false;
    } catch (e) {
      _error = e.toString();
      _page = _page > 0 ? _page - 1 : 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
