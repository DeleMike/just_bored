import 'package:flutter/foundation.dart';
import 'package:just_bored/configs/debug_fns.dart';

class AuthController with ChangeNotifier {
  /// control user auth view
  bool _wantsToLogin = true;

  /// control user auth view
  bool get wantsToLogin => _wantsToLogin;

  /// set if user wants login screen or register screen
  void setLogin(bool wantsLoginScreen) {
    _wantsToLogin = !wantsLoginScreen;
    printOut('wantsToLogin = $_wantsToLogin', 'AuthController');
    notifyListeners();
  }

  /// will reset all variables to default values
  void reset() {
    _wantsToLogin = true;
  }
}
