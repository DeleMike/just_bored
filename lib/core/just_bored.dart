import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding/onboarding.dart';
import '../configs/app_theme.dart';
import '../configs/constants.dart';

class JustBored extends StatelessWidget {
  const JustBored({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kLightPrimaryColor),
    );
    return MaterialApp(
      title: kAppName,
      theme: AppTheme(context).themeData(false),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
