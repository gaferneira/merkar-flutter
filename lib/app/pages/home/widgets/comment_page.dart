import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';

Future<void> CommentePage(BuildContext context) {
  final keyFormComments = GlobalKey<FormState>();
  String _message;
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
                      child: Form(
                        key: keyFormComments,
                        child: Column(
                          children: <Widget>[
                            Text(
                              Strings.label_top_comments,
                            ),
                            Text(Strings.label_body_comments),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: Strings.label_message),
                              onSaved: (value) {
                                _message = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Ingresa un mensaje";
                                } else
                                  return null;
                              },
                            ),
                            RaisedButton(
                              child: Text(Strings.label_send),
                              onPressed: () {
                                _sendEmail(_message);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]);
            },
          ),
        );
      });
}

Future<void> _sendEmail(message) async {
  try {
    print("Enviar mensaje Email");
    print('success');
  } catch (error) {
    print('Error: ${error}');
  }
}
