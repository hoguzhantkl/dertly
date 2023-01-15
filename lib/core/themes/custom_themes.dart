import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomThemes{
  static ThemeData get defaultTheme => ThemeData(
    primaryColor: CustomColors.black,
    scaffoldBackgroundColor: CustomColors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      shadowColor: Colors.black26,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),

      subtitle1: TextStyle(
        color: CustomColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      subtitle2: TextStyle(
        color: CustomColors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    iconTheme: const IconThemeData(
      color: CustomColors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: CustomColors.green,
      foregroundColor: CustomColors.white,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    primaryColor: Colors.grey
  );
}