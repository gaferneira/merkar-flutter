import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/pages/aboutus/about_us_page.dart';
import 'package:merkar/app/pages/comments/comment_page.dart';
import 'package:merkar/app/pages/new_shopping_list/new_shopping_list_page.dart';
import 'package:merkar/app/pages/purchase_history/purchase_history_page.dart';

enum DrawerOptions {
  route_new_list,
  route_purchase_history,
  route_comments,
  route_about_us,
  route_close_session
}

class DrawerWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    radius: 50.0,
                    //backgroundImage: Image.asset('asset/images/defaultprofile.png'),
                    child: Image.asset(
                      'assets/images/defaultprofile.png',
                      width: 87.0,
                      scale: 1.0,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Stip Yannin',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight + Alignment(0, 0.4),
                  child: Text(
                    'stip.suarez@gmail.com',
                    style: TextStyle(color: Colors.white70, fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(Strings.route_new_list),
            leading: Icon(Icons.shopping_cart),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute(DrawerOptions.route_new_list, context),
          ),
          Divider(),
          ListTile(
            title: Text(Strings.route_purchase_history),
            leading: Icon(Icons.history),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () =>
                _goToRoute(DrawerOptions.route_purchase_history, context),
          ),
          Divider(),
          ListTile(
            title: Text(Strings.route_comments),
            leading: Icon(Icons.comment),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute(DrawerOptions.route_comments, context),
          ),
          Divider(),
          ListTile(
            title: Text(Strings.route_about_us),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute(DrawerOptions.route_about_us, context),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.close,
              textDirection: TextDirection.rtl,
            ),
            title: Text(Strings.route_close_session),
            onTap: () => _goToRoute(DrawerOptions.route_close_session, context),
          ),
          Divider(),
        ],
      ),
    );
  }
}

void _goToRoute(DrawerOptions option, BuildContext context) async {
  switch (option) {
    case DrawerOptions.route_new_list:
      {
        Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
        break;
      }
    case DrawerOptions.route_purchase_history:
      {
        //cambiar
        Navigator.of(context).pushNamed(PurchaseHistoryPage.routeName);
        break;
      }
    case DrawerOptions.route_comments:
      {
        Navigator.of(context).pushNamed(CommentPage.routeName);
        break;
      }

    case DrawerOptions.route_about_us:
      {
        Navigator.of(context).pushNamed(AboutUsPage.routeName);
        break;
      }

    case DrawerOptions.route_close_session:
      {
        break;
      }
  }
}
