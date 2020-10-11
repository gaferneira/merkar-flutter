import 'package:flutter/cupertino.dart';
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
                            Strings.label_about_us +
                                " " +
                                Strings.label_name_app,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(""),
                          Row(children: <Widget>[
                            Text(
                              "Creadores",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          Text(""),
                          Row(
                            children: <Widget>[
                              Icon(Icons.touch_app),
                              Text(
                                Strings.creators_name[0],
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.touch_app),
                              Text(Strings.creators_name[1]),
                            ],
                          ),
                          Text(""),
                          Row(children: <Widget>[
                            Text(""),
                            Text(
                              "Escríbenos",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          Text(""),
                          Row(
                            children: <Widget>[
                              Icon(Icons.email),
                              Text(
                                Strings.creators_email[0],
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.alternate_email),
                              Text(Strings.creators_email[1]),
                            ],
                          ),
                          Text(""),
                          Row(
                            children: <Widget>[
                              Icon(Icons.tap_and_play),
                              Text(
                                Strings.creators_number,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Text(""),
                          Row(
                            children: <Widget>[
                              Icon(Icons.repeat_one),
                              Text(
                                Strings.name_repository,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          RaisedButton(
                            child: Text(Strings.label_close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
