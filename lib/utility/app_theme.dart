import 'package:flutter/material.dart';

// Color primaryColor = Color(0xff3f38c9);
Color primaryColorLightShade = Color(0xff3f38c9);

const Color primaryColor = Colors.indigo; // Indigo
const Color darkBackground = Color(0xFF0D0D0D); // Scaffold background
const Color surfaceColor = Color(0xFF1A1A1A); // Card/Tile background
const Color primaryTextColor = Color(0xFFffffff); // Main text
const Color secondaryTextColor = Color(0xFFA3A3A3); // Subtext
const Color borderColor = Color(0xFF2E2E2E); // Divider/border

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(primary: primaryColor),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.grey.shade900, weight: 1000),
      titleTextStyle: TextStyle(
          color: Colors.grey.shade900,
          fontSize: 22,
          fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    listTileTheme: ListTileThemeData(
      visualDensity: VisualDensity.comfortable,
    ),
  );

  // Dart Theme
  /*static ThemeData darkTheme = ThemeData(
    fontFamily: "Poppins",
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(primary: primaryColor),
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade900,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    listTileTheme: ListTileThemeData(
      visualDensity: VisualDensity.comfortable,
    ),
  );
  */

  static ThemeData darkTheme = ThemeData(
    fontFamily: "Poppins",
    dividerColor: borderColor,
    scaffoldBackgroundColor: darkBackground,
    iconTheme: const IconThemeData(color: secondaryTextColor),
    cardTheme: CardThemeData(
      color: surfaceColor,
      margin: EdgeInsets.all(0),

    ),
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSurface: primaryTextColor,
      secondary: primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceColor,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor),
      ),
      hintStyle: TextStyle(color: secondaryTextColor),
      labelStyle: TextStyle(color: primaryTextColor),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: surfaceColor,
      textColor: primaryTextColor,
      iconColor: secondaryTextColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      visualDensity: VisualDensity.comfortable,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: primaryTextColor),
      bodyMedium: TextStyle(color: secondaryTextColor),
      labelLarge: TextStyle(color: primaryTextColor),
    ),
  );
}
