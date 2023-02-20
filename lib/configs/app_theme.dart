import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

/// Creates light and dark [ThemeData].
class AppTheme {
  /// Light theme
  late ThemeData lightTheme;

  /// Dark theme
  late ThemeData darkTheme;

  /// Constructs an [AppTheme].
  AppTheme(BuildContext context) {
    lightTheme = ThemeData(
      fontFamily: GoogleFonts.quicksand().fontFamily,
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kCanvasColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kCanvasColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kCanvasColor,
        foregroundColor: kPrimaryColor,
        toolbarTextStyle: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.normal,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: kPrimaryColor),
      colorScheme: const ColorScheme.light(primary: Colors.indigo).copyWith(secondary: kPrimaryColor),
      buttonTheme: ButtonTheme.of(context).copyWith(
        buttonColor: kPrimaryColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return kPrimaryColor.withOpacity(.48);
          }
          return kPrimaryColor;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          return kPrimaryColor.withOpacity(.48);
        }),
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
            bodySmall: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            bodyMedium: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            bodyLarge: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            displayLarge: const TextStyle(
              fontSize: 57,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.normal,
              color: kWhite,
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
            ),
            headlineMedium: const TextStyle(
              fontSize: 28,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
            ),
            headlineSmall: const TextStyle(
              fontSize: 24,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
            ),
          ),
    );

    darkTheme = ThemeData(
      fontFamily: GoogleFonts.quicksand().fontFamily,
      brightness: Brightness.dark,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kBlack,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kCanvasColor,
      ),
      appBarTheme: const AppBarTheme(backgroundColor: kBlack),
      colorScheme: const ColorScheme.dark(primary: Color(0xFF17253D)).copyWith(secondary: kPrimaryColor),
      // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(secondary: kPrimaryColor),
      buttonTheme: ButtonTheme.of(context).copyWith(
        textTheme: ButtonTextTheme.primary,
        colorScheme: const ColorScheme.dark(primary: kBlack).copyWith(onPrimary: kWhite),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      iconTheme: const IconThemeData(color: kWhite),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return kPrimaryColor.withOpacity(.48);
          }
          return kPrimaryColor;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          return kPrimaryColor.withOpacity(.48);
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: kWhite),
      textTheme: ThemeData.light().textTheme.copyWith(
            bodySmall: const TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            bodyMedium: const TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            bodyLarge: const TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            displayLarge: const TextStyle(
              fontSize: 57,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.normal,
              color: kWhite,
            ),
            titleLarge: const TextStyle(
              fontSize: 22,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: const TextStyle(
              fontSize: 32,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
            ),
            headlineMedium: const TextStyle(
              fontSize: 28,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
            ),
            headlineSmall: const TextStyle(
              fontSize: 24,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w400,
            ),
          ),
    );
  }

  /// returns app current theme depending on if [isDarkMode] is ```true``` or otherwise
  ThemeData? themeData(bool isDarkModeOn) {
    return isDarkModeOn ? darkTheme : lightTheme;
  }
}
