import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_controller.dart';
import '../../../configs/constants.dart';

import 'login_form.dart';
import 'register_form.dart';

/// displays the login UI
class AuthScreen extends StatefulWidget {
  /// displays the login UI
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: Image.asset(AssetsImages.authBgImg, fit: BoxFit.cover),
          ),
          Center(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: context.watch<AuthController>().wantsToLogin
                        ? kScreenHeight(context) * 0.64
                        : kScreenHeight(context) * 0.90,
                    maxWidth: kScreenWidth(context) * 0.85),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey.shade50.withOpacity(0.4),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              padding: const EdgeInsets.all(kPaddingS - 5),
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(kSmallRadius),
                                  border: Border.all(color: kTransparent)),
                              child: Image.asset(AssetsImages.logoImg),
                            ),
                            SizedBox(width: kScreenWidth(context) * 0.05),
                            Text(
                              kAppName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                      const Divider(thickness: 1.0),
                      // display login fields

                      Consumer<AuthController>(
                        builder: (context, authController, _) => authController.wantsToLogin
                            ? LoginForm(wantsToLogin: authController.wantsToLogin)
                            : RegisterForm(wantsToLogin: authController.wantsToLogin),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
