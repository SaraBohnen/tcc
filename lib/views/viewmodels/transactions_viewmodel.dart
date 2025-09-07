// lib/views/viewmodels/transactions_viewmodel.dart
// ViewModel com paginação, refresh e estados – Provider/ChangeNotifier

import 'package:flutter/foundation.dart';
import 'package:app_chain_view/data/repositories/transactions_repository.dart';
import 'package:app_chain_view/models/transaction.dart';

class TransactionsViewModel extends ChangeNotifier {
  final TransactionsRepository repo;
  final int pageSize;

  TransactionsViewModel(this.repo, {this.pageSize = 20});

  final List<Transaction> _items = [];
  List<Transaction> get items => List.unmodifiable(_items);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _error;
  String? get error => _error;

  int _page = 0;

  Future<void> loadInitial() async {
    if (_isLoading) return;
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      _page = 0;
      final data = await repo.loadPage(page: _page, pageSize: pageSize, refresh: true);
      _items
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

  Future<void> refresh() async {
    if (_isRefreshing) return;
    _error = null;
    _isRefreshing = true;
    notifyListeners();
    try {
      _page = 0;
      final data = await repo.loadPage(page: _page, pageSize: pageSize, refresh: true);
      _items
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

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _page += 1;
      final data = await repo.loadPage(page: _page, pageSize: pageSize);
      _items.addAll(data);
      if (data.length < pageSize) _hasMore = false;
    } catch (e) {
      _error = e.toString();
      // Regride o contador de página se falhar
      _page = _page > 0 ? _page - 1 : 0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
