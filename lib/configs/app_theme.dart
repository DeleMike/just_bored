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
      colorScheme: const ColorScheme.light(primary: Color(0xFF17253D)).copyWith(secondary: kPrimaryColor),
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
            bodySmall: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: GoogleFonts.quicksand().fontFamily,
            ),
            bodyMedium: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontSize: 14,
            ),
            bodyLarge: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontSize: 16,
            ),
            displayLarge: TextStyle(
              fontSize: 57,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.normal,
              color: kWhite,
            ),
            titleLarge: TextStyle(
              fontSize: 22,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: TextStyle(
              fontSize: 32,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            headlineMedium: TextStyle(
              fontSize: 28,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontFamily: GoogleFonts.quicksand().fontFamily,
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
            bodySmall: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              fontFamily: GoogleFonts.quicksand().fontFamily,
            ),
            bodyMedium: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: GoogleFonts.quicksand().fontFamily,
            ),
            bodyLarge: TextStyle(
              color: kWhite,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: GoogleFonts.quicksand().fontFamily,
            ),
            displayLarge: TextStyle(
              fontSize: 57,
              fontWeight: FontWeight.normal,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              color: kWhite,
            ),
            titleLarge: TextStyle(
              fontSize: 22,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.bold,
            ),
            headlineLarge: TextStyle(
              fontSize: 32,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            headlineMedium: TextStyle(
              fontSize: 28,
              fontFamily: GoogleFonts.quicksand().fontFamily,
              fontWeight: FontWeight.w400,
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontFamily: GoogleFonts.quicksand().fontFamily,
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
