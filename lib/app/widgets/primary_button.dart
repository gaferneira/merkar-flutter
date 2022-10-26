import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final bool enable;

  PrimaryButton({required this.title, this.onPressed, this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: 250.0,
      child: ElevatedButton(
        onPressed: enable ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 10.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: enable ? Theme.of(context).colorScheme.primary : Colors.red,
        ),
        child: Text(
          title,
          style: TextStyle(
              color: Theme.of(context).colorScheme.surface,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
