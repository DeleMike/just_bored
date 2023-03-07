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
  /// 2 - Imagery
  void controlSelectedAICategory(BuildContext context, {required int categoryCode}) {
    switch (categoryCode) {
      case 1:
        printOut('AMA', 'AICategoryController');
        Navigator.of(context).pushNamed(Routes.ama);
        break;
      case 2:
        printOut('Image gen', 'AICategoryController');
        Navigator.of(context).pushNamed(Routes.imagery);
        break;
      default:
    }
  }
}
