import 'package:flutter/material.dart';
import '../../../../app/core/constants.dart';
import '../../../../app/core/strings.dart';
import '../../../../app/pages/login/register/register_view_model.dart';
import '../../../../injection_container.dart';
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
  String confirmPassword = "";

  final RegisterViewModel viewModel = serviceLocator<RegisterViewModel>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel?>.value(
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
                this.name = value ?? "";
              },
              validator: (value) {
                if (value?.isNotEmpty == true) {
                  return null;
                } else
                  return "Llene el nombre";
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              initialValue: "",
              decoration: InputDecoration(labelText: Strings.label_email),
              onSaved: (value) {
                this.email = value ?? "";
              },
              validator: (value) {
                if (value?.isNotEmpty == true) {
                  return null;
                } else
                  return "Llene el email";
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              initialValue: "",
              decoration: InputDecoration(labelText: Strings.label_password),
              onSaved: (value) {
                this.password = value ?? "";
              },
              onChanged: (value) {
                this.password = value;
              },
              validator: (value) {
                if (value?.isNotEmpty == true) {
                  return null;
                } else
                  return "La contraseña es requerida";
              },
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              initialValue: "",
              decoration:
                  InputDecoration(labelText: Strings.label_confirm_password),
              onSaved: (value) {
                this.confirmPassword = value ?? "";
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Confirme la contraseña";
                }
                if (value != this.password) {
                  return "Las constraseñas no coinciden";
                } else
                  return null;
              },
              keyboardType: TextInputType.text,
            ),
            ElevatedButton(
              child: Text(Strings.label_register),
              onPressed: () {
                if (key_form_register.currentState?.validate() == true) {
                  key_form_register.currentState!.save();
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
    viewModel.signUp(context, name, email, password);
  }
}
