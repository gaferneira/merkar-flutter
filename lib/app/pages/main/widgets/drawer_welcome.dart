import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../purchases/purchase_history/purchase_history_page.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/products/product_list/product_list_page.dart';
import '../../../pages/login/sign_in/login_view_model.dart';
import '../../../pages/main/widgets/about_us_page.dart';
import '../../../pages/main/widgets/comment_page.dart';
import '../../../../injection_container.dart';
enum DrawerOptions {
  route_new_list,
  route_purchase_history,
  route_comments,
  route_about_us,
  route_close_session,
  route_products,
}

class DrawerWelcome extends StatefulWidget {
  final String? displayName;
  final String? displayEmail;

  DrawerWelcome({this.displayName, this.displayEmail});

  @override
  _DrawerWelcomeState createState() =>
      _DrawerWelcomeState(this.displayName, this.displayEmail);
}

class _DrawerWelcomeState extends State<DrawerWelcome> {
  final InAppReview inAppReview = InAppReview.instance;
  String? displayName;
  String? displayEmail;
  _DrawerWelcomeState(this.displayName, this.displayEmail);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.lightColor),
            child: Stack(
              children: <Widget>[
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
                    displayName ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight + Alignment(0, 0.4),
                  child: Text(
                    displayEmail ?? "",
                    style: TextStyle(color: Colors.white70, fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
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
            onTap: () => _goToRoute(DrawerOptions.route_new_list, context),
          ),
          Divider(),
          ListTile(
            title: Text(Strings.route_purchase_history),
            leading: Icon(
              Icons.history,
              color: AppColors.lightColor,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.lightColor,
            ),
            onTap: () =>
                _goToRoute(DrawerOptions.route_purchase_history, context),
          ),
          Divider(),
          ListTile(
            title: Text(Strings.route_products),
            leading: Icon(
              Icons.favorite,
              color: AppColors.lightColor,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.lightColor,
            ),
            onTap: () => _goToRoute(DrawerOptions.route_products, context),
          ),
          Divider(),
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
            onTap: () => _goToRoute(DrawerOptions.route_comments, context),
          ),
          Divider(),
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
            onTap: () => _goToRoute(DrawerOptions.route_about_us, context),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.close,
              textDirection: TextDirection.rtl,
              color: AppColors.lightColor,
            ),
            title: Text(Strings.route_close_session),
            onTap: () => _goToRoute(DrawerOptions.route_close_session, context),
          ),
          Divider(),
        ],
      ),
    );
  }

  void _goToRoute(DrawerOptions option, BuildContext context) async {
    switch (option) {
      case DrawerOptions.route_new_list:
        {
          Navigator.of(context).pop();
         // Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
          break;
        }
      case DrawerOptions.route_products:
        {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(ProductsListPage.routeName);
          break;
        }
      case DrawerOptions.route_purchase_history:
        {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(PurchaseHistoryPage.routeName);
          break;
        }
      case DrawerOptions.route_comments:
        {
          Navigator.of(context).pop();
          CommentePage(context);
          break;
        }

      case DrawerOptions.route_about_us:
        {
          Navigator.of(context).pop();
          AboutUsPage(context);
          break;
        }

      case DrawerOptions.route_close_session:
        {
          final viewModel = serviceLocator<LoginViewModel>();
          viewModel.signOut();
          break;
        }
    }
  }
}
