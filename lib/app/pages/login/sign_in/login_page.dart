import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/login/sign_in/login_view_model.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  final viewModel = serviceLocator<LoginViewModel>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: viewModel,
      child: Consumer<LoginViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _key,
          appBar: AppBar(
            title: Text("Sign in"),
          ),
          body: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _email,
                      validator: (value) =>
                          (value.isEmpty) ? "Please Enter Email" : null,
                      style: style,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _password,
                      validator: (value) =>
                          (value.isEmpty) ? "Please Enter Password" : null,
                      style: style,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Password",
                          border: OutlineInputBorder()),
                    ),
                  ),
                  _createLoginButton(),
                  _createRegisterButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _createLoginButton() {
    if (viewModel.error != null) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text(viewModel.error),
      ));
      viewModel.error = null;
    }
    return viewModel.loading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.red,
              child: MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    viewModel.signIn(_email.text, _password.text);
                  }
                },
                child: Text(
                  "Sign In",
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget _createRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(Constant.normalspace),
      child: RaisedButton(
        child: Text(Strings.label_register),
        onPressed: () {
          _goToRegister();
        },
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.blue, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(50)),
        color: Colors.green,
        textColor: Colors.white,
        splashColor: Colors.grey,
      ),
    );
  }

  void _goToRegister() {
    Navigator.of(context).pushNamed(RegisterPage.routeName);
  }
}
