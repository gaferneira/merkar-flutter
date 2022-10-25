import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import '../../../core/resources/constants.dart';
import '../../../core/resources/strings.dart';
import '../../../widgets/primary_button.dart';

String? _message = "";
Future<void> CommentePage(BuildContext context) {
  final keyFormComments = GlobalKey<FormState>();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0; // Declare your variable outside the builder

        return FlipInY(
          child: AlertDialog(
            shape: AppStyles.borderRadiusDialog,
            content: SingleChildScrollView(
              child: StatefulBuilder(
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
                                Text(Strings.label_body_comments,
                                style: Theme.of(context).textTheme.bodyText1,),
                                SizedBox(height: Constant.normalspacecontainer,),
                                TextFormField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      labelText: Strings.label_message),
                                  onSaved: (value) {
                                    _message = value;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return Strings.error_required_field;
                                    } else
                                      return null;
                                  },
                                ),
                                PrimaryButton(title: Strings.label_send,
                                  onPressed: () {
                                  if (keyFormComments.currentState!
                                      .validate()) {
                                  keyFormComments.currentState!.save();
                                  _sendEmail(keyFormComments);
                                  Navigator.pop(context);
                                  }
                                }),
                              ],
                            ),
                          ),
                        ),
                      ]);
                },
              ),
            ),
          ),
        );
      });
}

Future<void> _sendEmail(GlobalKey<FormState> keyForm) async {
  try {
    final Email email = Email(
      body: Strings.comments+' '+Strings.label_name_app+':  $_message',
      subject: Strings.sugger+Strings.label_name_app,
      recipients: [Strings.creators_email.elementAt(0), Strings.creators_email.elementAt(1)],
      attachmentPaths: null,
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  } catch (error) {
    print(Strings.error+' ${error}');
  }
}
