import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';

class CommentPage extends StatefulWidget {
  static const routeName = "/comments";

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final keyFormComments = GlobalKey<FormState>();
  String _email;
  String _message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.comments),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constant.normalspace),
        child: Form(
          key: keyFormComments,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: Strings.label_email),
                onSaved: (value) {
                  this._email = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Ingresa un email";
                  } else
                    return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: Strings.label_message),
                onSaved: (value) {
                  this._message = value;
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
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
