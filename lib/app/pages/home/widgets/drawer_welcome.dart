import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/new_shopping_list/new_shopping_list_page.dart';

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
            title: Text(Constant.route_new_list),
            leading: Icon(Icons.shopping_cart),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute(Constant.route_new_list, context),
          ),
          Divider(),
          ListTile(
            title: Text(Constant.route_comments),
            leading: Icon(Icons.comment),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute(Constant.route_comments, context),
          ),
          Divider(),
          ListTile(
            title: Text(Constant.route_about_us),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute(Constant.route_about_us, context),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.close,
              textDirection: TextDirection.rtl,
            ),
            title: Text(Constant.route_close_session),
            onTap: () => _goToRoute(Constant.route_close_session, context),
          ),
          Divider(),
        ],
      ),
    );
  }
}

void _goToRoute(String routeName, BuildContext context) async {
  switch (routeName) {
    case Constant.route_new_list:
      {
        Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
        break;
      }
    case Constant.route_comments:
      {
        print("Ir a comentarios");
        break;
      }

    case Constant.route_about_us:
      {
        break;
      }

    case Constant.route_close_session:
      {
        break;
      }
  }
}
