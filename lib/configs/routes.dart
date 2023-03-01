import 'package:flutter/material.dart';
import 'package:just_bored/core/auth/screens/auth_screen.dart';
import 'package:just_bored/core/dashboard/ai/screens/ama/screens/ama_screen.dart';

import '../core/onboarding/onboarding.dart';

/// Defines established routes in the application
class Routes {
  /// Defines established routes in the application
  Routes();

  /// onboarding path
  static const onboarding = '/onboarding';

  /// auth path
  static const auth = '/auth';

  /// ama route
  static const ama = '/ama';

  /// facts routes
  static const facts = '/facts';

  /// jokes routes
  static const jokes = '/jokes';

  /// ai views routes
  static const aiViews = '/aiviews';

  Map<String, Widget Function(BuildContext)> generateRoutes(BuildContext context) {
    return {
      onboarding: (ctx) => const OnboardingScreen(),
      auth: (ctx) => const AuthScreen(),
      ama: (ctx) => const AmaScreen(),
    };
  }
}
