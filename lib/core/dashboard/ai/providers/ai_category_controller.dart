import 'package:flutter/material.dart';
import 'package:just_bored/configs/debug_fns.dart';

/// controls all functions for the AI & You Page
class AICategoryController with ChangeNotifier {
  /// controls all functions for the AI & You Page
  AICategoryController();

  /// manages what category is selected
  /// codes are:
  /// 
  /// 1 - AMA
  /// 
  /// 2 - Did you know?
  /// 
  /// 3 - Jokes & Riddles
  /// 
  /// 4 - AI Views
  void controlSelectedAICategory({required categoryCode}) {
    switch (categoryCode) {
      case 1:
        printOut('AMA', 'AICategoryController');
        break;
      case 2:
        printOut('Did you know?', 'AICategoryController');
        break;
      case 3:
        printOut('Jokes & Riddles', 'AICategoryController');
        break;
      case 4:
        printOut('AI Views', 'AICategoryController');
        break;
      default:
    }
  }
}
