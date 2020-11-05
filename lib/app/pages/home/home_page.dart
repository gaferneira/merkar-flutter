import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import '../shopping//new_shopping_list/new_shopping_list_page.dart';
import 'home_view_model.dart';
import 'widgets/drawer_welcome.dart';
import 'widgets/shopping_lists_display.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
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
    Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
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
          drawer: DrawerWelcome(),
          body: SingleChildScrollView(
            //scrollDirection: Axis.vertical,
            child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 150.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Colors.white70, Colors.white70],
                        // colors: [Colors.cyan[300], Colors.cyan[800]]
                      )),
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
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _goToCreateList,
            tooltip: Strings.label_tootip_new_list,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
