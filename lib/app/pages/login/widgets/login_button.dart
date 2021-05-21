import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final Function() onPressed;

  LoginButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
