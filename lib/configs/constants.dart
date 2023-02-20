import 'package:flutter/material.dart';

/// Defines the app's name
const String kAppName = 'Just Bored';

/// Defines app current version
const String kAppVersion = '1.0.0';

/// Theme font
const String kFontFamily = 'prompt';

// Colors
const Color kWhite = Color(0xFFFFFFFF);
const Color kBlack = Color(0xFF000000);
const Color kGrey = Color(0xFFEBEBEB);
const Color kCanvasColor = Color(0xFFF5F7FB);
const Color kLightBlack = Colors.black26;
const Color kPrimaryColor = Color(0xFF17253D);
const Color kLightPrimaryColor = Color(0xFFD9DFEF);
const Color veryLightBlueColor = Color(0xFFA4AEC4);
const Color lightBlueColor = Color(0xFF7281A0);
const Color kAccentColor = Color(0xFFFF9800);
const Color kDarkTextColor = kPrimaryColor;
const Color kLightTextColor = Color(0xFFEEF0F4);
const Color blueOneVariantColor = Color(0xFF9DA4A4);
const Color blueTwoVariantColor = Color(0xFF686C6C);
const Color blueThreeVariantColor = Color(0xFF5c749a);
const Color kDividerColor = Color(0xFFBDBDBD);
const Color kRed = Color(0xFF960000);
const Color kGreen = Color(0xFF285D34);
const Color kTransparent = Colors.transparent;

// Padding
const double kPaddingS = 10.0;
const double kPaddingM = 20.0;
const double kPaddingL = 40.0;

// Border Radius
const double kSmallRadius = 12.0;
const double kMediumRadius = 20.0;
const double kLargeRadius = 50.0;

const double kButtonHeight = 52.0;
const double kCardElevation = 5.0;
const double kButtonRadius = 10.0;
const double kDialogRadius = 20.0;

/// Get screen height
double kScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// Get screen width
double kScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// Get screen orientation
Orientation kGetOrientation(BuildContext context) {
  return MediaQuery.of(context).orientation;
}

/// Assets images
class AssetsImages {}

/// Assets Animations
class AssetsAnimations {}
