import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.black,
    scaffoldBackgroundColor: AppColors.white,
    canvasColor: AppColors.white,
    fontFamily: 'Pretendard',

    // Text Theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.black),
      bodyMedium: TextStyle(color: AppColors.black),
      displayLarge: TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
      displayMedium: TextStyle(color: AppColors.black),
      bodySmall: TextStyle(color: AppColors.mediumGray),
    ),

    // App Bar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle: TextStyle(
        color: AppColors.black,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Toggle
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.white; // 활성화된 상태의 thumb 색상
        }
        return AppColors.white; // 비활성화된 상태의 thumb 색상
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.black; // 활성화된 상태의 track 색상
        }
        return AppColors.mediumGray; // 비활성화된 상태의 track 색상
      }),
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent)
    ),
  );


  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.white,
    scaffoldBackgroundColor: AppColors.black,
    canvasColor: AppColors.black,
    fontFamily: 'Pretendard',

    // Text Theme
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.white),
      bodyMedium: TextStyle(color: AppColors.white),
      displayLarge: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
      displayMedium: TextStyle(color: AppColors.white),
      bodySmall: TextStyle(color: AppColors.mediumGray),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
