import 'package:flutter/material.dart';

class AppViewmodel extends ChangeNotifier {
  /// gerencia o índice da aba selecionada
  /// e notifica listeners quando há mudança.
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
