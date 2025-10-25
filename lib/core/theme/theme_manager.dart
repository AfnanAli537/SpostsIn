import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/core/constants/color_manager.dart';


class ThemeManager {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: ColorManager.lightPrimary,
        secondary: ColorManager.lightAccent,
        surface: ColorManager.lightSurface,
        background: ColorManager.lightBackground,
        error: ColorManager.error,
        onPrimary: ColorManager.lightBackground,
        onSecondary: ColorManager.lightPrimary,
        onSurface: ColorManager.lightTextPrimary,
        onBackground: ColorManager.lightTextPrimary,
        onError: ColorManager.lightBorder,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: ColorManager.lightBackground,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.lightBackground,
        foregroundColor: ColorManager.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorManager.black),
        titleTextStyle: GoogleFonts.lexend(
          color: ColorManager.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ColorManager.lightTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ColorManager.lightTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ColorManager.lightTextPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ColorManager.lightTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorManager.lightTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ColorManager.lightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorManager.lightTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorManager.lightTextPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorManager.lightTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColorManager.lightTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: ColorManager.lightTextPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ColorManager.lightTextSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorManager.lightTextPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorManager.lightTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: ColorManager.lightTextSecondary,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.lightPrimary,
          foregroundColor: ColorManager.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: ColorManager.lightAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorManager.lightPrimary,
          side: BorderSide(color: ColorManager.lightBorder, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorManager.lightBlack,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      


 inputDecorationTheme: InputDecorationTheme(
  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: ColorManager.borderColor, 
      width: 1.0,
    ),
  ),
  
  
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: ColorManager.borderColor, 
      width: 1.0,
    ),
  ),
  
  
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(
      color: ColorManager.focusColor, 
      width: 2.0, 
    ),
  ),

  filled: true,
  fillColor: ColorManager.borderColor.withOpacity(0.05), 
  
  
  hintStyle: const TextStyle(
    color: ColorManager.hintTextColor,
    fontSize: 16.0,
   
    fontWeight: FontWeight.w400, 
  ),
  
  
  prefixIconColor: ColorManager.hintTextColor, 
  suffixIconColor: ColorManager.hintTextColor,
),
      // Input Decoration
      // inputDecorationTheme: InputDecorationTheme(
      //   filled: true,
      //   fillColor: ColorManager.lightSurface,
      //   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: BorderSide(color: ColorManager.lightBorder),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: BorderSide(color: ColorManager.lightBorder),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: BorderSide(color: ColorManager.lightPrimary, width: 2),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: BorderSide(color: ColorManager.error),
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: BorderSide(color: ColorManager.error, width: 2),
      //   ),
      //   labelStyle: TextStyle(color: ColorManager.lightTextSecondary),
      //   hintStyle: TextStyle(color: ColorManager.lightTextSecondary),
      // ),
      
      // Card
      cardTheme: CardThemeData(
        color: ColorManager.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: ColorManager.lightBorder, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ) ,
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorManager.lightSurface,
        selectedItemColor: ColorManager.lightPrimary,
        unselectedItemColor: ColorManager.lightTextSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        // selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        // unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: ColorManager.lightBorder,
        thickness: 1,
        space: 1,
      ),
      
      // Icon
      iconTheme: IconThemeData(
        color: ColorManager.lightTextPrimary,
        size: 24,
      ),
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: ColorManager.darkPrimary,
        secondary: ColorManager.darkAccent,
        surface: ColorManager.darkSurface,
        background: ColorManager.darkBackground,
        error: ColorManager.error,
        onPrimary: ColorManager.black,
        onSecondary: ColorManager.black,
        onSurface: ColorManager.darkTextPrimary,
        onBackground: ColorManager.darkTextPrimary,
        onError: ColorManager.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: ColorManager.darkSurface,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.darkSurface,
        foregroundColor: ColorManager.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorManager.darkAccent),
        titleTextStyle: GoogleFonts.lexend(
          color: ColorManager.darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: ColorManager.darkTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: ColorManager.darkTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ColorManager.darkTextPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ColorManager.darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ColorManager.darkTextPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ColorManager.darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkTextPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkTextPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: ColorManager.darkTextPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: ColorManager.darkTextPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: ColorManager.darkTextSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkTextPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkTextSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkTextSecondary,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.darkPrimary,
          foregroundColor: ColorManager.black,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColorManager.darkPrimary,
          side: BorderSide(color: ColorManager.darkBorder, width: 1.5),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorManager.lightAccent,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColorManager.darkSurface,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: ColorManager.error, width: 2),
        ),
        labelStyle: TextStyle(color: ColorManager.darkTextSecondary),
        hintStyle: TextStyle(color: ColorManager.darkTextSecondary),
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: ColorManager.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: ColorManager.darkBorder, width: 1),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorManager.darkSurface,
        selectedItemColor: ColorManager.darkPrimary,
        unselectedItemColor: ColorManager.darkTextSecondary,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        // selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        // unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: ColorManager.darkBorder,
        thickness: 1,
        space: 1,
      ),
      
      // Icon
      iconTheme: IconThemeData(
        color: ColorManager.darkTextPrimary,
        size: 24,
      ),
    );
  }
}