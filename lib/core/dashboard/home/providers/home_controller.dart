import 'package:flutter/material.dart';

import '../../../../configs/debug_fns.dart';

/// controls & manages home screen
class HomeController with ChangeNotifier {
  /// controls & manages home screen
  HomeController();

  String _selectedMood = '';

  /// user selected mood
  String get selectedMood => _selectedMood;

  /// for mood change
  ///
  /// if the user selects an already selected mood, it clears away
  ///
  /// else it sets that selected mood as the current mood
  void selectMood(String mood) {
    if (_selectedMood == mood) {
      _selectedMood = 'none';
    } else {
      _selectedMood = mood;
    }
    printOut('Update Mood = $_selectedMood', 'Home Controller');
    notifyListeners();
  }

  /// sets user reflection
  /// This will be allowed only twice a day, morning hours at 10am and evening hours at 8pm
  void setUserReflection({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Map<String, String> userReflection,
  }) {
    final isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      printOut(userReflection, 'Reflection');
    }
  }

  /// reset all [HomeController] variable
  void reset() {
    _selectedMood = '';
  }
}
