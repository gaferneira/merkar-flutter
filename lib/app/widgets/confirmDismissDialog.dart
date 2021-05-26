import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/strings.dart';

Future<bool> ConfirmDismissDialog (BuildContext context,DismissDirection) async{
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: AppStyles.borderRadiusDialog,
          // contentPadding: EdgeInsets.only(top: 10.0),
          title: Center(child: const Text(Strings.confirm)),
          content: const Text("Estás seguro de eliminar el Elemento?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(Strings.calcel),
            ),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(Strings.delete)),
          ],
        );
      },
    );
}

