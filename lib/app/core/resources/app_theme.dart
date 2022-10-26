import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {

  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: AppColors.primaryDarkColor,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      primaryVariant: AppColors.primaryDarkColor,
      secondary: AppColors.secondaryColor,
      secondaryVariant: AppColors.secondaryDarkColor,
      surface: Colors.white
  ),
    cardTheme: CardTheme(
      color: Colors.teal,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: defaultTextTheme,
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black87,
    accentColor: Colors.blue[200]!,
    appBarTheme: AppBarTheme(
      color: Colors.grey[800]!,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[200]!,
      onPrimary: Colors.black,
      primaryVariant: Colors.blue[700]!,
      secondary: Colors.grey,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: defaultTextTheme,
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final ThemeData loginTheme = ThemeData.from(
    colorScheme : ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white,
        primaryVariant: Color(0xFF205592),
        secondary: Colors.black12,
        onSecondary: Colors.grey,
        surface: Colors.white,
        onSurface: Color(0xFF205592)
    ),
    textTheme: defaultTextTheme
  );

  static final TextTheme defaultTextTheme = TextTheme(
    headline1 : TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 96.0,
    ),
    headline2 : TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 60.0,
    ),
    headline3 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 48.0,
    ),
    headline4 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 34.0,
    ),
    headline5 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 24.0,
    ),
    headline6 : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
    ),

    subtitle1 : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),

    subtitle2 : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),

    bodyText1 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
    ),

    bodyText2 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
    ),

    button : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),

    caption : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
    ),

    overline : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10.0,
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    headline1 : TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 96.0,
      color: Colors.white,
    ),
    headline2 : TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 60.0,
      color: Colors.white,
    ),
    headline3 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 48.0,
      color: Colors.white,
    ),
    headline4 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 34.0,
      color: Colors.white,
    ),
    headline5 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 24.0,
      color: Colors.white,
    ),
    headline6 : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20.0,
      color: Colors.white,
    ),

    subtitle1 : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
      color: Colors.white70,
    ),

    subtitle2 : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: Colors.white,
    ),

    bodyText1 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
      color: Colors.white,
    ),

    bodyText2 : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
      color: Colors.white,
    ),

    button : TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: Colors.white,
    ),

    caption : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
      color: Colors.white,
    ),

    overline : TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10.0,
      color: Colors.white,
    ),

  );

}
