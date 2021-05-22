import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {

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
        color: AppColors.textColorButtonDark,
      ),
      borderRadius: BorderRadius.circular(18.0));
  static BoxDecoration listDecoration(index){
    return BoxDecoration(
    borderRadius: BorderRadius.all(
    Radius.circular(25)
    ),
    color: index.isOdd ? Colors.lightBlueAccent : Colors.black38,
    );
  }
}
