import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  static const TextStyle h1TextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 96.0,
  );
  static const TextStyle h2TextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 60.0,
  );
  static const TextStyle h3TextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 48.0,
  );
  static const TextStyle h4TextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 34.0,
  );
  static const TextStyle h5TextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 24.0,
  );
  static const TextStyle h6TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
  );

  static const TextStyle subtitle1TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
  );

  static const TextStyle subtitle2TextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
  );

  static const TextStyle body1TextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );

  static const TextStyle body2TextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
  );

  static const TextStyle captionTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
  );

  static const TextStyle overlineTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 10.0,
  );

  static final kHintTextStyle = TextStyle(
    color: Colors.white54
  );

  static final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  static RoundedRectangleBorder borderRadius = RoundedRectangleBorder(
      side: BorderSide(
        color: AppColors.textColorButtomDark,
      ),
      borderRadius: BorderRadius.circular(18.0));
}
