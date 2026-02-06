// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class ThemeManager {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
        onSecondaryFixed: ColorManager.lightAccent,
        onPrimaryFixed: ColorManager.lightTextPrimary,
        onInverseSurface: ColorManager.lightBackground,
        onSurfaceVariant: ColorManager.lightAccent, 
        onTertiaryFixed: ColorManager.lightPrimary,
        onTertiary: ColorManager.lightPrimaryText,
        onTertiaryContainer:ColorManager.borderCircular, 
        
      ),
      scaffoldBackgroundColor: ColorManager.lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.lightBackground,
        foregroundColor: ColorManager.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorManager.black, size: 24.sp),
        titleTextStyle: GoogleFonts.lexend(
          color: ColorManager.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),

      textTheme: _textTheme(ColorManager.black),
      elevatedButtonTheme: _elevatedButtonTheme(ColorManager.lightPrimary),
      outlinedButtonTheme: _outlinedButtonTheme(
        ColorManager.lightPrimary,
        ColorManager.white,
      ),
      textButtonTheme: _textButtonTheme(ColorManager.lightBlack),

      inputDecorationTheme: _inputDecorationTheme(
        ColorManager.darkTextSecondary,
        ColorManager.focusColor,
        ColorManager.focusColor,
        0.10,
      ),

      cardTheme: CardThemeData(
        color: ColorManager.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: ColorManager.lightBorder, width: 1.w),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorManager.lightSurface,
        selectedItemColor: ColorManager.lightPrimary,
        unselectedItemColor: ColorManager.lightTextSecondary,
        elevation: 8,
      ),

      dividerTheme: DividerThemeData(
        color: ColorManager.darkSurface,
        thickness: 1.w,
        space: 1.h,
      ),

      iconTheme: IconThemeData(
        color: ColorManager.lightTextPrimary,
        size: 24.sp,
      ),
    );
  }


  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark, 
      colorScheme: ColorScheme.dark(
        primary: ColorManager.darkPrimary,
        secondary: ColorManager.darkAccent,
        surface: ColorManager.darkSurface,
        background: ColorManager.darkBackground,
        error: ColorManager.error,
        onPrimary: ColorManager.darkBackground,
        onSecondary: ColorManager.darkPrimary,
        onSurface: ColorManager.darkTextPrimary,
        onBackground: ColorManager.darkTextPrimary,
        onError: ColorManager.lightBorder,
        onSecondaryFixed: ColorManager.lightPrimary,
        onPrimaryFixed: ColorManager.darkAccent,
        onInverseSurface: ColorManager.lightPrimary,
        onSurfaceVariant: ColorManager.darkPrimary, 
        onTertiaryFixed: ColorManager.darkAccent,
        onTertiary: ColorManager.darkPrimaryText
        onTertiaryContainer:ColorManager.darkPrimary, 



      ),
      scaffoldBackgroundColor: ColorManager.darkBackground,

      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.darkBackground,
        foregroundColor: ColorManager.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: ColorManager.white, size: 24.sp),
        titleTextStyle: GoogleFonts.lexend(
          color: ColorManager.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),

      textTheme: _textTheme(ColorManager.lightBackground),
      elevatedButtonTheme: _elevatedButtonTheme(ColorManager.darkPrimary),
      outlinedButtonTheme: _outlinedButtonTheme(
        ColorManager.darkPrimary,
        ColorManager.lightPrimary,
      ),
      textButtonTheme: _textButtonTheme(ColorManager.white),

      inputDecorationTheme: _inputDecorationTheme(
        ColorManager.darkGrey,
        ColorManager.darkPrimary,
        ColorManager.lightBorder,
        0.50,
      ),

      cardTheme: CardThemeData(
        color: ColorManager.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: ColorManager.darkBorder, width: 1.w),
        ),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorManager.darkSurface,
        selectedItemColor: ColorManager.darkPrimary,
        unselectedItemColor: ColorManager.darkTextSecondary,
        elevation: 8,
      ),

      dividerTheme: DividerThemeData(
        color: ColorManager.lightBackground,
        thickness: 1.w,
        space: 1.h,
      ),

      iconTheme: IconThemeData(
        color: ColorManager.darkTextPrimary,
        size: 24.sp,
      ),
    );
  }

  /// Shared theme functions

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: color),
      displayMedium: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: color),
      displaySmall: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.bold, color: color,height: 1.9),
      headlineLarge: GoogleFonts.poppins(fontSize: 22.sp, fontWeight: FontWeight.bold, color: color),
      headlineMedium: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: color),
      headlineSmall: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w700, color: color),
      titleLarge: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600, color: color),
      titleMedium: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500, color: color,height: 1.4),
      titleSmall: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w300, color: color,height: 1.6),
      bodyLarge: GoogleFonts.inter(fontSize: 16.sp, color: color,fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.poppins(fontSize: 14.sp, color: color),
      bodySmall: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w400, color: color),
      labelLarge: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w300, color: color),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color bgColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        // foregroundColor: ,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color fgColor, Color borderColor) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: fgColor,
        side: BorderSide(color: borderColor, width: 1.5.w),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(Color fgColor) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: fgColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        textStyle: GoogleFonts.inter(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    Color borderColor,
    Color focusColor,
    Color hintColor,
     double fillOpacity,
  ) {
    return InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: hintColor, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: hintColor, width: 1.w),
      ),
      errorBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: ColorManager.errorColor, width: 1.w),
      ), 
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: focusColor, width: 2.w),
      ),
      filled: true,
      fillColor:borderColor.withOpacity(fillOpacity) ,
     
      hintStyle: TextStyle(
        color: hintColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      labelStyle:TextStyle(
        color: hintColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ), 
      prefixIconColor: hintColor,
      suffixIconColor: hintColor,
    );
  }
}
