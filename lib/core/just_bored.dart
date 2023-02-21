import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_bored/configs/routes.dart';
import 'package:just_bored/core/auth/providers/auth_controller.dart';
import 'package:provider/provider.dart';

import '../local/onboarding_prefs.dart';
import '../configs/app_theme.dart';
import '../configs/constants.dart';

import 'onboarding/onboarding.dart';

class JustBored extends StatelessWidget {
  const JustBored({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kLightPrimaryColor),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => OnboardingPrefs(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthController(),
        )
      ],
      child: MaterialApp(
        title: kAppName,
        theme: AppTheme(context).themeData(false),
        home: Consumer<OnboardingPrefs>(
          builder: (_, onBoardingcontroller, __) => FutureBuilder(
            future: onBoardingcontroller.checkOnboardingViewStatus(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (onBoardingcontroller.showAuthScreen) {
                return const Placeholder(); // show authscreen
              } else {
                // show onbaording
                return const OnboardingScreen();
              }
            },
          ),
        ),
        routes: Routes().generateRoutes(context),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
