import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_bored/configs/debug_fns.dart';
import 'package:just_bored/configs/routes.dart';
import 'package:just_bored/core/auth/providers/auth_controller.dart';
import 'package:just_bored/core/auth/screens/auth_screen.dart';
import 'package:just_bored/local/profile_prefs.dart';
import 'package:provider/provider.dart';

import '../local/onboarding_prefs.dart';
import '../configs/app_theme.dart';
import '../configs/constants.dart';

import 'dashboard/nav_screen.dart';
import 'onboarding/onboarding.dart';

class JustBored extends StatelessWidget {
  const JustBored({super.key});

  void save(BuildContext context, dynamic data) async {
    await context.read<ProfilePrefs>().saveUser(data);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kPrimaryColor),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => OnboardingPrefs(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfilePrefs(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthController(),
        )
      ],
      child: MaterialApp(
        title: kAppName,
        theme: AppTheme(context).themeData(false),
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: messengerKey,
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
                return StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Scaffold(body: Center(child: CircularProgressIndicator()));
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Something went wrong while trying to sign you in...'));
                      } else if (snapshot.hasData) {
                        // save user data props
                        save(context, snapshot.data);
                        printOut(snapshot.data!.toString(), 'Home');
                        return const NavScreen();
                      } else {
                        return const AuthScreen();
                      }
                    });
                // ; // show authscreen
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
