import 'package:flutter/material.dart';

class AppTheme {

  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.teal,
    appBarTheme: AppBarTheme(
      color: Colors.teal,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.white,
      primaryVariant: Colors.white38,
      secondary: Colors.red,
    ),
    cardTheme: CardTheme(
      color: Colors.teal,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: defaultTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      onPrimary: Colors.black,
      primaryVariant: Colors.black,
      secondary: Colors.red,
    ),
    cardTheme: CardTheme(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: defaultTextTheme
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
}
