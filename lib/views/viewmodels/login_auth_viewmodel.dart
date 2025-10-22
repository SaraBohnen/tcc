// lib/viewmodels/login_auth_viewmodel.dart
// ViewModel para autenticação local (biometria / PIN)
// Regra: se não houver biometria disponível, permitir somente PIN.
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

  // Há algum tipo de biometria disponível e cadastrada no dispositivo?
  bool get hasBiometrics =>
      _canCheckBiometrics && _availableBiometrics.isNotEmpty;

  // Inicializa verificando suporte e recursos disponíveis
  Future<void> init() async {
    try {
      _isSupported = await _auth.isDeviceSupported();
      _canCheckBiometrics = await _auth.canCheckBiometrics;
      _availableBiometrics = await _auth.getAvailableBiometrics();
    } catch (e) {
      _lastError = e.toString();
    }
    notifyListeners();
  }

  // Autenticação usando biometria apenas
  Future<bool> authenticateWithBiometrics({
    String reason = 'Authenticate to continue',
  }) async {
    _setAuthenticating(true);
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true, // apenas biometria
      );
      _authenticated = ok;
      return ok;
    } catch (e) {
      _lastError = e.toString();
      return false;
    } finally {
      _setAuthenticating(false);
    }
  }

  // Autenticação permitindo credencial do dispositivo (PIN/padrão/senha)
  Future<bool> authenticateWithDeviceCredential({
    String reason = 'Authenticate to continue',
  }) async {
    _setAuthenticating(true);
    try {
      final ok = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false, // permite PIN/Passcode
      );
      _authenticated = ok;
      return ok;
    } catch (e) {
      _lastError = e.toString();
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
}
