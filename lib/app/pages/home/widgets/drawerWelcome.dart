import 'package:flutter/material.dart';
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
            title: Text('Nueva lista'),
            leading: Icon(Icons.shopping_cart),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute('Nueva lista', context),
          ),
          Divider(),
          ListTile(
            title: Text('Comentarios'),
            leading: Icon(Icons.comment),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute('Comentarios', context),
          ),
          Divider(),
          ListTile(
            title: Text('Acerca de'),
            leading: Icon(Icons.info),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => _goToRoute('Acerca de', context),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.close,
              textDirection: TextDirection.rtl,
            ),
            title: Text('Cerrar Sesión'),
            onTap: () => _goToRoute('Cerrar Sesión', context),
          ),
          Divider(),
        ],
      ),
    );
  }
}

void _goToRoute(String routeName, BuildContext context) async {
  print("Redireccionar con navegator");
  switch (routeName) {
    case 'Nueva lista':
      {
        Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
        break;
      }
    case 'Comentarios':
      {
        print("Ir a comentarios");
        break;
      }

    case 'Acerca de':
      {
        break;
      }

    case 'Cerrar Sesión':
      {
        break;
      }
  }
}
