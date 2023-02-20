/// All debug mode functions defined here

import 'package:flutter/foundation.dart';

/// print messages to the console only in debug mode
/// 
/// [title] - incase you want to add the module where this print function is triggered
/// 
/// [message] - the message to print out
void printOut(String message, [String title = '']) {
  if (kDebugMode) {
    if (title.isNotEmpty) {
      debugPrint('$title: $message');
    } else {
      debugPrint(message);
    }
  }
}
