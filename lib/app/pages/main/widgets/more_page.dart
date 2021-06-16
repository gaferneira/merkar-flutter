import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/login/sign_in/login_view_model.dart';
import '../../../pages/main/widgets/about_us_page.dart';
import '../../../pages/main/widgets/comment_page.dart';
import '../../../../injection_container.dart';

class MorePage extends StatefulWidget {
  String? displayName;
  String? displayEmail;

  MorePage({this.displayName, this.displayEmail});
  @override
  State<StatefulWidget> createState() =>
      MorePageState( this.displayName,this.displayEmail);
}

class MorePageState extends State<MorePage> {

  String? displayName;
  String? displayEmail;
  MorePageState(this.displayName,this.displayEmail);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            // Then, the content of your dialog.
            mainAxisSize: MainAxisSize.min,
            children: [
              /*SizedBox(
                width: double.infinity,
                height: 20.0,
              ),*/
              Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryVariant),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                backgroundImage:
                                AssetImage('assets/images/defaultprofile.png'),
                                backgroundColor: Colors.transparent,
                                radius: 50.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                displayName ?? "Nombre: ",
                                style: TextStyle(color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight + Alignment(0, 0.4),
                              child: Text(
                                displayEmail ?? "Email: ",
                                style: TextStyle(color: Colors.white70, fontSize: 15.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              ListTile(
                title: Text(Strings.route_comments),
                leading: Icon(
                  Icons.comment,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => _goToRoute(0, context),
              ),
              SizedBox(height: 30.0),
              ListTile(
                title: Text(Strings.route_about_us),
                leading: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: () => _goToRoute(1, context),
              ),
              SizedBox(height: 30.0),
              ListTile(
                leading: Icon(
                  Icons.close,
                  textDirection: TextDirection.rtl,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(Strings.route_close_session),
                onTap: () => _goToRoute(2, context),
              ),
            ]),
      ),
    );
  }

  void _goToRoute(int option, BuildContext context) async {
    switch (option) {
      case 0:
        {
          CommentePage(context);
          break;
        }
      case 1:
        {
          AboutUsPage(context);
          break;
        }
      case 2:
        {
          final viewModel = serviceLocator<LoginViewModel>();
          viewModel.signOut();
          break;
        }
    }
  }
}
