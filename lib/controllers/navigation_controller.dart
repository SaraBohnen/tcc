// lib/controllers/navigation_controller.dart

import 'package:flutter/material.dart';

/// NavigationController gerencia o índice da aba selecionada
/// e notifica listeners quando há mudança.
class NavigationController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  /// Altera a aba selecionada
  void setIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
