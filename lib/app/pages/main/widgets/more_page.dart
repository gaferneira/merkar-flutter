import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_colors.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/login/sign_in/login_view_model.dart';
import 'package:merkar/app/pages/main/widgets/about_us_page.dart';
import 'package:merkar/app/pages/main/widgets/comment_page.dart';
import 'package:merkar/injection_container.dart';

class MorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MorePageState();
}

class MorePageState extends State<MorePage> {

  var _currentTab = 0;

  void _selectTab(var index) {
    setState(() => _currentTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          // Then, the content of your dialog.
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
            ),
            SizedBox(height: 30.0),
            ListTile(
              title: Text(Strings.route_comments),
              leading: Icon(
                Icons.comment,
                color: AppColors.lightColor,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.lightColor,
              ),
              onTap: () => _goToRoute(0, context),
            ),
            SizedBox(height: 30.0),
            ListTile(
              title: Text(Strings.route_about_us),
              leading: Icon(
                Icons.info,
                color: AppColors.lightColor,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.lightColor,
              ),
              onTap: () => _goToRoute(1, context),
            ),
            SizedBox(height: 30.0),
            ListTile(
              leading: Icon(
                Icons.close,
                textDirection: TextDirection.rtl,
                color: AppColors.lightColor,
              ),
              title: Text(Strings.route_close_session),
              onTap: () => _goToRoute(2, context),
            ),
          ]),
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
