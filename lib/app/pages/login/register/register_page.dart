import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/app_theme.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/login/register/register_view_model.dart';
import '../../../pages/login/widgets/background_login.dart';
import '../../../pages/login/widgets/login_button.dart';
import '../../../../injection_container.dart';


class RegisterPage extends StatefulWidget {
  static const routeName = "/register";

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  String _name = "";
  String _email = "";
  String _password = "";

  final RegisterViewModel viewModel = serviceLocator<RegisterViewModel>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext buildContext) {
    return ChangeNotifierProvider<RegisterViewModel>.value(
        value: viewModel,
        child: Consumer<RegisterViewModel>(
            builder: (context, model, child) => Theme(
                  data: AppTheme.loginTheme,
                  child: Builder(
                    builder: (context) => ScaffoldMessenger(
                      key: scaffoldMessengerKey,
                      child: Scaffold(
                        body: _showFormRegister(context),
                      ),
                    ),
                  ),
                )));
  }

  Widget _showFormRegister(BuildContext context) {
    return Form(
      key: formKey,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: <Widget>[
          BackgroundLogin(),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 60.0,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    Strings.label_register,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 30.0),
                  _buildNameTextField(context),
                  SizedBox(height: 30.0),
                  _buildEmailTextField(context),
                  SizedBox(height: 30.0),
                  _buildPasswordTextField(context),
                  SizedBox(height: 30.0),
                  _buildConfirmPasswordTextField(context),
                  SizedBox(height: 30.0),
                  _buildRegisterButton(context),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildNameTextField(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.label_name,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: AppStyles.kBoxDecorationStyle,
            height: 60.0,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                hintText: Strings.login_hint_enter_name,
                hintStyle: AppStyles.kHintTextStyle,
              ),
              onSaved: (value) {
                this._name = value ?? "";
              },
              validator: (value) {
                if (value?.isNotEmpty == true) {
                  return null;
                } else
                  return Strings.login_hint_enter_name;
              },
              textInputAction: TextInputAction.next,
            ),
          ),
        ]);
  }

  Widget _buildEmailTextField(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.label_email,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(height: 10.0),
          Container(
              alignment: Alignment.centerLeft,
              decoration: AppStyles.kBoxDecorationStyle,
              height: 60.0,
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  hintText: Strings.login_hint_enter_email,
                  hintStyle: AppStyles.kHintTextStyle,
                ),
                onSaved: (value) {
                  this._email = value ?? "";
                },
                validator: (value) {
                  if (value?.isNotEmpty == true) {
                    return null;
                  } else
                    return Strings.login_hint_enter_email;
                },
                textInputAction: TextInputAction.next,
              )),
        ]);
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.label_password,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(height: 10.0),
          Container(
              alignment: Alignment.centerLeft,
              decoration: AppStyles.kBoxDecorationStyle,
              height: 60.0,
              child: TextFormField(
                obscureText: _obscurePassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye_sharp,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_obscurePassword)
                          _obscurePassword = false;
                        else
                          _obscurePassword = true;
                      });
                    },
                  ),
                  hintText: Strings.login_hint_enter_password,
                  hintStyle: AppStyles.kHintTextStyle,
                ),
                onSaved: (value) {
                  this._password = value ?? "";
                },
                onChanged: (value) {
                  this._password = value;
                },
                validator: (value) {
                  if (value?.isNotEmpty == true) {
                    return null;
                  } else
                    return Strings.login_hint_enter_password;
                },
              )),
        ]);
  }

  Widget _buildConfirmPasswordTextField(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.label_confirm_password,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(height: 10.0),
          Container(
              alignment: Alignment.centerLeft,
              decoration: AppStyles.kBoxDecorationStyle,
              height: 60.0,
              child: TextFormField(
                obscureText: _obscureConfirmPassword,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye_sharp,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_obscureConfirmPassword)
                          _obscureConfirmPassword = false;
                        else
                          _obscureConfirmPassword = true;
                      });
                    },
                  ),
                  hintText: Strings.login_hint_confirm_password,
                  hintStyle: AppStyles.kHintTextStyle,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.login_hint_confirm_password;
                  }
                  if (value != this._password) {
                    return Strings.login_hint_password_diferents;
                  } else
                    return null;
                },
                textInputAction: TextInputAction.done,
              )),
        ]);
  }

  Widget _buildRegisterButton(BuildContext context) {
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
    }
    return LoginButton(
        title: Strings.label_button_register,
        onPressed: () {
          if (formKey.currentState?.validate() == true) {
            formKey.currentState!.save();
            viewModel.signUp(context, _name, _email, _password);
          }
        });
  }
}
