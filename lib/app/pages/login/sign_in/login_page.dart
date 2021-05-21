import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merkar/app/core/resources/app_images.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/app_theme.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/login/reset_password/reset_password_page.dart';
import 'package:merkar/app/pages/login/sign_in/login_view_model.dart';
import 'package:merkar/app/pages/login/widgets/background_login.dart';
import 'package:merkar/app/pages/login/widgets/login_button.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = serviceLocator<LoginViewModel>();

  final _formLogginKey = GlobalKey<FormState>();
  String? _email="";
  String? _password="";

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool _obscurePassword=true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return ChangeNotifierProvider<LoginViewModel>.value(
        value: viewModel,
        child: Consumer<LoginViewModel>(
          builder: (context, model, child) => Theme(
            data: AppTheme.loginTheme,
            child: Builder(
              builder: (context) => ScaffoldMessenger(
                key: scaffoldMessengerKey,
                child: Scaffold(
                  body: Form(
                    key: _formLogginKey,
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Stack(
                        children: <Widget>[
                          BackgroundLogin(),
                          Container(
                            height: double.infinity,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: 40.0,
                                vertical: 60.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    Strings.login_label_title,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  SizedBox(height: 30.0),
                                  _buildEmailTextField(context),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  _buildPasswordTextField(context),
                                  _buildForgotPasswordButton(context),
                                  _buildLoginButton(context),
                                  _buildSignInWithText(context),
                                  _buildGmailButton(context),
                                  _buildSignupButton(context),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildEmailTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Strings.login_label_email,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: AppStyles.kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
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
            onSaved: (value){
              _email=value;
            },
            validator: (value) =>
                (value?.isEmpty == false) ? null : Strings.error_required_field,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Strings.login_label_password,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: AppStyles.kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: _obscurePassword,
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
                onPressed: (){
                  setState(() {
                    if(_obscurePassword)
                    _obscurePassword=false;
                    else _obscurePassword=true;
                  });
                },
              ),
              hintText: Strings.login_hint_enter_password,
              hintStyle: AppStyles.kHintTextStyle,
            ),
            onSaved: (value){
              _password=value;
            },
            validator: (value) =>
                (value?.isEmpty == false) ? null : Strings.error_required_field,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => {
          Navigator.of(context).pushNamed(ResetPasswordPage.routeName)
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.only(right: 0.0),
            primary: Theme.of(context).colorScheme.onPrimary),
        child: Text(
          Strings.login_action_recover_password,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
      }
      return viewModel.loading
          ? Center(child: CircularProgressIndicator())
          : LoginButton(
          title: Strings.login_action_login,
          onPressed: () {
            if (_formLogginKey.currentState!.validate()) {
              _formLogginKey.currentState!.save();
              viewModel.signIn(
                  _email!, _password!);
            }
          });
  }

  Widget _buildSignInWithText(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 20.0),
        Text(
          Strings.login_label_sign_in,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }

  Widget _buildGmailButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          viewModel.signInWithGoogle();
        },
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
            image: DecorationImage(image: AssetImage(AppImages.logoGoogle)),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: GestureDetector(
        onTap: () => {Navigator.of(context).pushNamed(RegisterPage.routeName)},
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: Strings.login_label_dont_have_account,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              TextSpan(
                text: Strings.login_action_sign_up,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
