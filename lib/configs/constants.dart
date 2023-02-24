import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Defines the app's name
const String kAppName = 'Just Bored';

/// Defines app current version
const String kAppVersion = '1.0.0';

/// Theme font
const String kFontFamily = 'prompt';

/// navigator key
final navigatorKey = GlobalKey<NavigatorState>();

/// messenger key
final messengerKey = GlobalKey<ScaffoldMessengerState>();

// Colors
const Color kWhite = Color(0xFFFFFFFF);
const Color kBlack = Color(0xFF000000);
const Color kGrey = Color(0xFFEBEBEB);
const Color kCanvasColor = Color(0xFFF5F7FB);
const Color kLightBlack = Colors.black26;
const Color kPrimaryColor = Color(0xFF17253D);
const Color kLightPrimaryColor = Color(0xFFD9DFEF);
const Color kVeryLightBlueColor = Color(0xFFA4AEC4);
const Color kLightBlueColor = Color(0xFF7281A0);
const Color kAccentColor = Color(0xFFFF9800);
const Color kDarkTextColor = kPrimaryColor;
const Color kLightTextColor = Color(0xFFEEF0F4);
const Color kBlueOneVariantColor = Color(0xFF9DA4A4);
const Color kBlueTwoVariantColor = Color(0xFF686C6C);
const Color kBlueThreeVariantColor = Color(0xFF5c749a);
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

/// show Snackbar
void showASnackbar(BuildContext context, String message, [Color? color]) {
  final snackbar = SnackBar(
    backgroundColor: color ?? kPrimaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kMediumRadius)),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    content: Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite),
    ),
  );

  messengerKey.currentState!
    ..removeCurrentSnackBar()
    ..showSnackBar(snackbar);
}

/// Show toast with [message]
void showToast(String message, {wantsLongText = false}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: wantsLongText ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kPrimaryColor,
      textColor: kWhite,
      fontSize: 16.0);
}

/// Assets images
class AssetsImages {
  static const String onboardingImgOne = 'assets/images/onboarding/illustration_peace.png';
  static const String onboardingImgTwo = 'assets/images/onboarding/illustration_calm.png';
  static const String onboardingImgThree = 'assets/images/onboarding/illustration_bored.png';
  static const String authBgImg = 'assets/images/auth/auth_pic.png';
  static const String logoImg = 'assets/images/dashboard/mental_health.png';
  static const String googleIcon = 'assets/images/auth/google_icon.png';
  static const String happyEmoji = 'assets/images/emojis/happy.png';
  static const String sadEmoji = 'assets/images/emojis/sad.png';
  static const String loveEmoji = 'assets/images/emojis/in_love.png';
  static const String depressedEmoji = 'assets/images/emojis/depression.png';
}

/// Assets Animations
class AssetsAnimations {}
