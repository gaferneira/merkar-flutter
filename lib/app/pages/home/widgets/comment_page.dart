import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';

String _message = "";
Future<void> CommentePage(BuildContext context) {
  final keyFormComments = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0; // Declare your variable outside the builder

        return FlipInY(
          child: AlertDialog(
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
                              SizedBox(height: 20),
                              Text(Strings.label_body_comments),
                              TextFormField(
                                autofocus: true,
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
                                  if (keyFormComments.currentState.validate()) {
                                    keyFormComments.currentState.save();
                                    _sendEmail(keyFormComments);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]);
              },
            ),
          ),
        );
      });
}

Future<void> _sendEmail(GlobalKey<FormState> keyForm) async {
  try {
//    print(keyForm.currentState.validate());
    print("Enviar mensaje Email: ${_message}");
    final Email email = Email(
      body: 'Merkar Comment: ${_message}',
      subject: 'Sugerencia',
      recipients: ['stip.suarez@gmail.com', 'gabrielfneira@gmail.com'],
      cc: null,
      bcc: null,
      attachmentPaths: null,
      isHTML: false,
    );

    await FlutterEmailSender.send(email);

    print('success');

    return "Error";
  } catch (error) {
    print('Error: ${error}');
  }
}
