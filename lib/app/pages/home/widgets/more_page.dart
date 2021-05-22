import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_colors.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/home/widgets/about_us_page.dart';
import 'package:merkar/app/pages/home/widgets/comment_page.dart';
import 'package:merkar/app/pages/shopping/new_shopping_list/new_shopping_list_page.dart';
import 'package:merkar/app/pages/login/sign_in/login_view_model.dart';
import 'package:merkar/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> MorePage(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0; // Declare your variable outside the builder

        return FlipInX(
          child: AlertDialog(
            content: StatefulBuilder(
              // You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                    // Then, the content of your dialog.
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(Strings.route_new_list),
                        leading: Icon(
                          Icons.shopping_cart,
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
                        title: Text(Strings.route_comments),
                        leading: Icon(
                          Icons.comment,
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
                        title: Text(Strings.route_about_us),
                        leading: Icon(
                          Icons.info,
                          color: AppColors.lightColor,
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.lightColor,
                        ),
                        onTap: () => _goToRoute(2, context),
                      ),
                      SizedBox(height: 30.0),
                      ListTile(
                        leading: Icon(
                          Icons.close,
                          textDirection: TextDirection.rtl,
                          color: AppColors.lightColor,
                        ),
                        title: Text(Strings.route_close_session),
                        onTap: () => _goToRoute(3, context),
                      ),

                    ]
                );
              },
            ),
          ),
        );
      });
}
void _goToRoute(int option, BuildContext context) async {
  Navigator.pop(context);
  switch (option) {
    case 0:
      {
        Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
        break;
      }
    case 1:
      {
        CommentePage(context);
        break;
      }
    case 2:
      {
        AboutUsPage(context);
        break;
      }
    case 3:
      {
        final viewModel = serviceLocator<LoginViewModel>();
        viewModel.signOut();
        break;
      }
  }
}
