import 'package:flutter/material.dart';
import 'package:just_bored/configs/debug_fns.dart';
import 'package:just_bored/configs/routes.dart';

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
  void controlSelectedAICategory(BuildContext context, {required int categoryCode}) {
    switch (categoryCode) {
      case 1:
        printOut('AMA', 'AICategoryController');
        Navigator.of(context).pushNamed(Routes.ama);
        break;
      case 2:
        printOut('Did you know?', 'AICategoryController');
        break;
      case 3:
        printOut('Jokes & Riddles', 'AICategoryController');
        break;
      case 4:
        printOut('Image gen', 'AICategoryController');
        break;
      default:
    }
  }
}
