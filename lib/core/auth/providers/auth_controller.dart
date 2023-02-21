import 'package:flutter/material.dart';

import '../../../configs/debug_fns.dart';

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

  /// register user with email-password
  void createUserWithEmailAndPassword({
    required BuildContext context,
    required Map<String, dynamic> data,
    required GlobalKey<FormState> formKey,
  }) {
    printOut('Email Register', 'AuthController');
    FocusScope.of(context).unfocus(); //close keyboard

    //validate data from the frontend
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
      printOut('UserData = $data', 'Email Login');
    }
  }

  /// register user with google social
  void createUserWithGoogleAcct() {
    printOut('Google Register', 'AuthController');
  }

  /// user email-password sign in
  void loginUserWithEmailAndPassword({
    required BuildContext context,
    required Map<String, dynamic> data,
    required GlobalKey<FormState> formKey,
  }) {
    FocusScope.of(context).unfocus(); //close keyboard

    //validate data from the frontend
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
      printOut('UserData = $data', 'Email Login');
    }
  }

  /// user google sign in
  void loginUserWithGoogleAcct({
    required BuildContext context,
  }) {
    printOut('Google Sign In', 'AuthController');
  }

  /// will reset all variables to default values
  void reset() {
    _wantsToLogin = true;
  }
}
