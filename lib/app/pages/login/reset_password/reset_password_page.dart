import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/app_theme.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/login/reset_password/reset_password_view_model.dart';
import 'package:merkar/app/pages/login/widgets/background_login.dart';
import 'package:merkar/app/pages/login/widgets/login_button.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';


class ResetPasswordPage extends StatefulWidget {
  static const routeName = "/resetpassword";
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final viewModel = serviceLocator<ResetPasswordViewModel>();

  final _formRessetPasswordKey = GlobalKey<FormState>();
  String? _email="";

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return ChangeNotifierProvider<ResetPasswordViewModel>.value(
        value: viewModel,
        child: Consumer<ResetPasswordViewModel>(
          builder: (context, model, child) => Theme(
            data: AppTheme.loginTheme,
            child: Builder(
              builder: (context) => ScaffoldMessenger(
                key: scaffoldMessengerKey,
                child: Scaffold(
                  body: Form(
                    key: _formRessetPasswordKey,
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
                                    Strings.label_restore_password,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  SizedBox(height: 30.0),
                                  _buildEmailTextField(context),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  _buildResetPasswordButton(context),
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

  Widget _buildResetPasswordButton(BuildContext context) {
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
      }
      return viewModel.loading
          ? Center(child: CircularProgressIndicator())
          : LoginButton(
          title: Strings.login_action_reset,
          onPressed: () {
            if (_formRessetPasswordKey.currentState!.validate()) {
              _formRessetPasswordKey.currentState!.save();
              viewModel.recoverPassword(
                  _email!, context);
            }
          });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
