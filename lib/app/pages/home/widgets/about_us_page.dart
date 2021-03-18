import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/core/constants.dart';
import '../../../../app/core/strings.dart';

Future<void> AboutUsPage(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {

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
                          Container(
                            width: double.infinity,
                            height: 150.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [Colors.white70, Colors.white70],
                              // colors: [Colors.cyan[300], Colors.cyan[800]]
                            )),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 10.0,
                              // color: Colors.black,
                            ),
                          ),
                          Text(
                            Strings.label_about_us +
                                " " +
                                Strings.label_name_app,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(""),
                          Row(children: <Widget>[
                            Text(
                              "Creadores: ",
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
                              "Escríbenos: ",
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
                              InkWell(
                                onTap: () {
                                  launch(
                                      'https://github.com/gaferneira/merkar-flutter');
                                },
                                child: Text(
                                  Strings.name_repository,
                                  textAlign: TextAlign.center,
                                ),
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
