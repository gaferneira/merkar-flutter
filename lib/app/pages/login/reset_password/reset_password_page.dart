import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/app_theme.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/login/reset_password/reset_password_view_model.dart';
import '../../../pages/login/widgets/background_login.dart';
import '../../../pages/login/widgets/login_button.dart';
import '../../../../injection_container.dart';

class ResetPasswordPage extends StatefulWidget {
  static const routeName = "/resetpassword";

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final viewModel = serviceLocator<ResetPasswordViewModel>();

  final _formKey = GlobalKey<FormState>();
  String? _email = "";

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    _email = ModalRoute.of(buildContext)!.settings.arguments as String? ?? "";
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
                    key: _formKey,
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
                                horizontal: 30.0,
                                vertical: 40.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                 
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_back),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },),),
                                      Expanded(
                                        child: Text(
                                          Strings.label_restore_password,
                                          style:
                                              Theme.of(context).textTheme.headline4,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
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
            initialValue: _email,
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
            onSaved: (value) {
              _email = value;
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
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                viewModel.recoverPassword(_email!, context);
              }
            });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
