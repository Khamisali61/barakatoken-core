import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primaryColor = Color(0xFF008F58); // #008F58
  static const goldColor = Color(0xFFC5A021); // #C5A021
  static const backgroundColor = Color(0xFF0A0A0A); // Dark emerald/black
  static const glassCardColor = Color(0x08FFFFFF);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      surface: Color(0xFF121212),
      background: backgroundColor,
    ),
    textTheme: GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
    ),
  );
}
