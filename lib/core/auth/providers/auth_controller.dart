import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_bored/configs/constants.dart';

import '../../../configs/debug_fns.dart';

class AuthController with ChangeNotifier {
  /// control user auth view
  bool _wantsToLogin = true;

  /// control user auth view
  bool get wantsToLogin => _wantsToLogin;

  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;

  /// set if user wants login screen or register screen
  void setLogin(bool wantsLoginScreen) {
    _wantsToLogin = !wantsLoginScreen;
    printOut('wantsToLogin = $_wantsToLogin', 'AuthController');
    notifyListeners();
  }

  /// register user with email-password
  Future<void> createUserWithEmailAndPassword({
    required BuildContext context,
    required Map<String, dynamic> data,
    required GlobalKey<FormState> formKey,
  }) async {
    printOut('Email Register', 'AuthController');
    FocusScope.of(context).unfocus(); //close keyboard

    //validate data from the frontend
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
      printOut('UserData = $data', 'Email Login');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        //_isAuthenticating = true;
        // clean the strings
        String email = data['email'].toString().trim();
        String password = data['password'].toString().trim();

        // create user with firebase
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        showASnackbar(context, e.message ?? 'An error occurred while creating your account', kRed);
      } catch (e, s) {
        printOut(e);
        printOut(s);
      }
      //_isAuthenticating = false;
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      // notifyListeners()
    }
  }

  /// register user with google social
  void createUserWithGoogleAcct() {
    printOut('Google Register', 'AuthController');
  }

  /// user email-password sign in
  Future<void> loginUserWithEmailAndPassword({
    required BuildContext context,
    required Map<String, dynamic> data,
    required GlobalKey<FormState> formKey,
  }) async {
    FocusScope.of(context).unfocus(); //close keyboard

    //validate data from the frontend
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();
      printOut('UserData = $data', 'Email Login');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      try {
        //_isAuthenticating = true;
        // clean the strings
        String email = data['email'].toString().trim();
        String password = data['password'].toString().trim();

        // sign in a registered user
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        showASnackbar(context, e.message ?? 'An error occurred while creating your account', kRed);
      } catch (e, s) {
        printOut(e);
        printOut(s);
      }
      //_isAuthenticating = false;
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      //notifyListeners();
    }
  }

  /// user google sign in
  void loginUserWithGoogleAcct({
    required BuildContext context,
  }) {
    printOut('Google Sign In', 'AuthController');
  }

  /// sign out user from the app
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      showASnackbar(context, e.message ?? 'An error occurred while logging out. Try again.', kRed);
    } catch (e, s) {
      printOut(e);
      printOut(s);
    }
  }

  /// will reset all variables to default values
  void reset() {
    _wantsToLogin = true;
    _isAuthenticating = false;
  }
}
