// lib/views/viewmodels/wallet_setup_viewmodel.dart
// ViewModel para cadastro de carteira: valida, acumula em `wallets` (StringList)
// e mantém compatibilidade com `walletAddress` (última selecionada).
// Comentários em pt-BR.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_chain_view/utils/sample_data_generator.dart';

class WalletSetupViewmodel extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();

  String? _errorText;
  bool _isSaving = false;

  String get value => controller.text;
  String? get errorText => _errorText;
  bool get isSaving => _isSaving;

  // 🔹 Limpa erro ao digitar
  void onChanged(String v) {
    if (_errorText != null) {
      _errorText = null;
      notifyListeners();
    }
  }

  void setSaving(bool v) {
    _isSaving = v;
    notifyListeners();
  }

  // 🔹 Validação simples (usa os endereços conhecidos do SampleDataGenerator)
  bool _isValidAddress(String addr) {
    final v = addr.trim();
    if (v.isEmpty) return false;
    // Se quiser permitir qualquer endereço, troque a linha abaixo para: return v.isNotEmpty;
    return SampleDataGenerator.isKnownWallet(v);
  }

  // 🔹 Persiste a carteira:
  // - adiciona à lista `wallets` (sem duplicar, case-insensitive)
  // - grava também em `walletAddress` (última/selecionada)
  Future<void> _appendWalletToPrefs(String rawAddress) async {
    final addr = rawAddress.trim();
    final sp = await SharedPreferences.getInstance();

    final list = sp.getStringList('wallets') ?? <String>[];

    final exists = list.any((w) => w.trim().toLowerCase() == addr.toLowerCase());
    if (!exists) {
      list.add(addr);
      await sp.setStringList('wallets', list);
    }

    // Compatibilidade + seleção recente
    await sp.setString('walletAddress', addr);
  }

  // 🔹 Ação de salvar chamada pela UI (ex.: botão "Adicionar")
  // Retorna true se salvou, false se houve erro de validação.
  Future<bool> saveWallet() async {
    final addr = controller.text.trim();

    if (!_isValidAddress(addr)) {
      _errorText = 'Endereço de carteira inválido.';
      notifyListeners();
      return false;
    }

    setSaving(true);
    try {
      await _appendWalletToPrefs(addr);
      return true;
    } catch (e) {
      _errorText = 'Falha ao salvar a carteira. Tente novamente.';
      notifyListeners();
      return false;
    } finally {
      setSaving(false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
