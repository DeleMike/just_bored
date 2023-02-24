import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../configs/debug_fns.dart';

/// Manages onboarding screen preferences
class OnboardingPrefs extends ChangeNotifier {
  /// Manages onboarding screen preferences
  OnboardingPrefs();

  bool _showAuthScreen = false;
  static const showOnboardingKey = 'showOnboarding';

  /// show onboarding status
  bool get showAuthScreen => _showAuthScreen;

  /// Save onboarding view status to `true`
  ///  this is because the user has seen this screen one time and has no need to view it again
  Future<void> saveOnBoardingViewStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(showOnboardingKey, true);
  }

  ///  get onboarding viewing status
  Future<void> checkOnboardingViewStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _showAuthScreen =
        prefs.getBool(showOnboardingKey) ?? false; // return false if user has never viewed onboarding

    printOut('showAuthScreen = $_showAuthScreen', 'onBoarding');
  }
}
