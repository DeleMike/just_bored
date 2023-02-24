import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_bored/configs/constants.dart';

import '../../../configs/debug_fns.dart';

class AuthController with ChangeNotifier {
  /// control user auth view
  bool _wantsToLogin = true;

  /// control user auth view
  bool get wantsToLogin => _wantsToLogin;

  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;

  String _fullname = '';
  String get fullname => _fullname;

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
        _fullname = data['fullname'].toString().trim();
        String email = data['email'].toString().trim();
        String password = data['password'].toString().trim();

        // create user with firebase

        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((credential) {
          // Update the user's display name
          credential.user?.updateDisplayName(_fullname);
          FirebaseAuth.instance.currentUser?.reload();
        });
      } on FirebaseAuthException catch (e) {
        showASnackbar(context, e.message ?? 'An error occurred while creating your account', kRed);
      } catch (e, s) {
        printOut(e);
        printOut(s);
      }
      //_isAuthenticating = false;
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      notifyListeners();
    }
  }

  /// register user and sign with Federated identity & social sign-in using Google
  Future<void> createUserOrSignInWithGoogleAcct({required BuildContext context}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // sign in the user.
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      showASnackbar(context, e.message ?? 'An error occurred while creating your account', kRed);
    } catch (e, s) {
      printOut(e);
      printOut(s);
    }
    //_isAuthenticating = false;
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
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
