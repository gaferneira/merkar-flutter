import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/login/register/register_view_model.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/register";
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final key_form_register = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  String confirm_password = "";

  final viewModel = serviceLocator<RegisterViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>.value(
        value: viewModel,
        child: Consumer<RegisterViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text(Strings.label_register),
                  ),
                  body: _showFormRegister(),
                )));
  }

  Widget _showFormRegister() {
    return Padding(
      padding: const EdgeInsets.all(Constant.normalspace),
      child: Form(
        key: key_form_register,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: "",
              decoration: InputDecoration(labelText: Strings.label_name),
              onSaved: (value) {
                this.name = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene el nombre";
                } else
                  return null;
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              initialValue: "",
              decoration: InputDecoration(labelText: Strings.label_email),
              onSaved: (value) {
                this.email = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene el email";
                } else
                  return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              initialValue: "",
              decoration: InputDecoration(labelText: Strings.label_password),
              onSaved: (value) {
                this.password = value;
              },
              onChanged: (value) {
                this.password = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene el nombre";
                } else
                  return null;
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              initialValue: "",
              decoration:
                  InputDecoration(labelText: Strings.label_confirm_password),
              onSaved: (value) {
                this.confirm_password = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene el nombre";
                }
                if (value != this.password) {
                  return "Las constraseñas no coinciden";
                } else
                  return null;
              },
              keyboardType: TextInputType.text,
            ),
            RaisedButton(
              child: Text(Strings.label_register),
              onPressed: () {
                if (key_form_register.currentState.validate()) {
                  key_form_register.currentState.save();
                  _registerNewUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _registerNewUser() {
    viewModel.signUp(name, email, password);
  }
}
