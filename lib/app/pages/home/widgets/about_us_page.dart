import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';

Future<void> AboutUsPage(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0; // Declare your variable outside the builder

        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                  // Then, the content of your dialog.
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Constant.normalspace),
                      child: Column(
                        children: <Widget>[
                          Text(
                            Strings.label_top_comments,
                          ),
                          Text(Strings.label_body_comments),
                          RaisedButton(
                            child: Text(Strings.label_send),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ]);
            },
          ),
        );
      });
}
