import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navilaw/utils/colors.dart';

class AppTheme {
  static const Color primaryColor = Colors.brown;
  static const Color buttonTextColor = Colors.white;

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      canvasColor: primaryColor,
      useMaterial3: true,
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
      scaffoldBackgroundColor: AppColors.backgroundColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: buttonTextColor, 
        ),
      ),
    );
  }
}
