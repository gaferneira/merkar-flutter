import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constant {
  static const double normalspace = 10.0;
  static const double bottomBarHeight = 75.0;

  static const double raduiusBorder = 50.0;

  static const TextStyle resaltText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  static const TextStyle boldText = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const Color lightColor = Colors.indigo;
  static const Color lightColorAcent = Colors.indigoAccent;
  static const Color textColorButtomLight = Colors.white;
  static const Color errorColor = Colors.red;

  static const Color darkColor = Colors.amber;
  static const Color darkColorAcent = Colors.amberAccent;
  static const Color textColorButtomDark = Colors.black;

  static RoundedRectangleBorder borderRadius = RoundedRectangleBorder(
      side: BorderSide(
        color: Constant.textColorButtomDark,
      ),
      borderRadius: BorderRadius.circular(18.0));
}
