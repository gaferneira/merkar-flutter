import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/home/home_view_model.dart';
import 'package:merkar/app/pages/home/widgets/shopping_lists_display.dart';
import 'package:merkar/app/pages/new_shopping_list/new_shopping_list_page.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/constants.dart';
import '../new_shopping_list/new_shopping_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel = serviceLocator<HomePageViewModel>();

  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  void _goToCreateList() async {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => NewShoppingListPage()));
    Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
  }

  void _goToRoute(String routeName) async {
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

  @override
  Widget build(BuildContext context) {
    final _scaffKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider<HomePageViewModel>(
      create: (context) => viewModel,
      child: Consumer<HomePageViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            title: Text('Merkar'),
          ),
          drawer: _drawerWelcome(context),
          body: Column(

              //  crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 150.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.cyan[300], Colors.cyan[800]])),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 10.0,
                      // color: Colors.black,
                    ),
                  ),
                ]),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (viewModel.list == null)
                        ? Center(child: LoadingWidget())
                        : shoppingListsDisplay(viewModel.list),
                  ],
                ),
              ]),
          floatingActionButton: FloatingActionButton(
            onPressed: _goToCreateList,
            tooltip: 'New Shopping List',
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _drawerWelcome(BuildContext context) {
    final List listdrawer = Constant.listdrawer;
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
                    child: Image.asset('asset/images/defaultprofile.png'),
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
            onTap: () => _goToRoute('Nueva lista'),
          ),
          ListTile(
            title: Text('Comentarios'),
            onTap: () => _goToRoute('Comentarios'),
          ),
          ListTile(
            title: Text('Acerca de'),
            onTap: () => _goToRoute('Acerca de'),
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            onTap: () => _goToRoute('Cerrar Sesión'),
          ),
        ],
      ),
      /*ListView.builder(
        itemCount: listdrawer.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${listdrawer[index]}'),
            onTap: () {
              _goToRoute('${listdrawer[index]}');
            },
          );
        },
      ),*/
    );
  }
}
