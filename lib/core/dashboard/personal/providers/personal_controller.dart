import 'package:flutter/material.dart';
import 'package:just_bored/configs/debug_fns.dart';

/// controls all functions for the AI & You Page
class PersonalController with ChangeNotifier {
  /// controls all functions for the AI & You Page
  PersonalController();

  /// manages what category is selected
  /// codes are:
  ///
  /// 1 - Settings
  ///
  /// 2 - View mood logs
  ///
  /// 3 - View reflections
  void controlSelectedPersonalCategory({required categoryCode}) {
    switch (categoryCode) {
      case 1:
        printOut('View Settings', 'PersonalController');
        break;
      case 2:
        printOut('view mood logs', 'PersonalController');
        break;
      case 3:
        printOut('View reflection', 'PersonalController');
        break;
      default:
        printOut('Not possible', 'PersonalController');
    }
  }
}
