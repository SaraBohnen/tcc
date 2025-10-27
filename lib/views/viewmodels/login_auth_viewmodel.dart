// lib/viewmodels/login_auth_viewmodel.dart
// ViewModel para autenticação local (biometria / PIN)
// Compatível com local_auth: ^3.0.0

import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class LoginAuthViewModel extends ChangeNotifier {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isSupported = false;
  bool _canCheckBiometrics = false;
  bool _isAuthenticating = false;
  bool _authenticated = false;
  String? _lastError;
  List<BiometricType> _availableBiometrics = const [];

  bool get isSupported => _isSupported;
  bool get canCheckBiometrics => _canCheckBiometrics;
  bool get isAuthenticating => _isAuthenticating;
  bool get authenticated => _authenticated;
  String? get lastError => _lastError;

  bool get hasBiometrics =>
      _canCheckBiometrics && _availableBiometrics.isNotEmpty;

  Future<void> init() async {
    try {
      _isSupported = await _auth.isDeviceSupported();
      _canCheckBiometrics = await _auth.canCheckBiometrics;
      _availableBiometrics = await _auth.getAvailableBiometrics();
      _lastError = null;
    } catch (e) {
      _lastError = _mapError(e);
    }
    notifyListeners();
  }

  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to continue',
  }) async {
    _setAuthenticating(true);
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
      _authenticated = ok;
      _lastError = ok ? null : 'Biometria não reconhecida. Tente novamente.';
      return ok;
    } catch (e) {
      _lastError = _mapError(e);
      return false;
    } finally {
      _setAuthenticating(false);
    }
  }

  Future<bool> authenticateWithDeviceCredential({
    String reason = 'Authenticate to continue',
  }) async {
    _setAuthenticating(true);
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
      );
      _authenticated = ok;
      _lastError = ok
          ? null
          : 'Não foi possível autenticar. Verifique o PIN/senha e tente novamente.';
      return ok;
    } catch (e) {
      _lastError = _mapError(e);
      return false;
    } finally {
      _setAuthenticating(false);
    }
  }

  void reset() {
    _authenticated = false;
    _lastError = null;
    notifyListeners();
  }

  void _setAuthenticating(bool v) {
    _isAuthenticating = v;
    notifyListeners();
  }

  String _mapError(Object e) {
    if (e is LocalAuthException) {
      final code = e.code ?? '';
      if (code == 'noCredentialsSet') {
        return 'O dispositivo não possui credenciais de bloqueio configuradas. Defina um PIN/senha nas configurações e tente novamente.';
      }
      if (code == 'notEnrolled') {
        return 'Nenhuma biometria cadastrada. Cadastre sua biometria nas configurações do dispositivo.';
      }
      if (code == 'notAvailable') {
        return 'Autenticação local indisponível neste dispositivo.';
      }
      if (code == 'lockedOut' || code == 'permanentlyLockedOut') {
        return 'Muitas tentativas falhas. Tente novamente mais tarde.';
      }
      // 🔧 Ajuste: algumas versões não expõem 'message'
      final fallback = e.toString();
      return fallback.isNotEmpty ? fallback : 'Falha na autenticação local.';
    }

    final s = e.toString();
    if (s.contains('noCredentialsSet')) {
      return 'O dispositivo não possui credenciais de bloqueio configuradas. Defina um PIN/senha nas configurações e tente novamente.';
    }
    if (s.contains('notEnrolled')) {
      return 'Nenhuma biometria cadastrada. Cadastre sua biometria nas configurações do dispositivo.';
    }
    if (s.contains('notAvailable')) {
      return 'Autenticação local indisponível neste dispositivo.';
    }
    if (s.contains('lockedOut')) {
      return 'Muitas tentativas falhas. Tente novamente mais tarde.';
    }

    return 'Autenticação falhou. Verifique as credenciais do dispositivo.';
  }
}
