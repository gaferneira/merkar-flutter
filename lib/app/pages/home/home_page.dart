import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:provider/provider.dart';

import '../../../app/core/strings.dart';
import '../../../app/widgets/widgets.dart';
import '../../../injection_container.dart';
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
  bool _light = true;
  final _key_search = GlobalKey<FormState>();
  TextEditingController _search_textController =
      TextEditingController(); //controller search_text
  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  void _goToCreateList() async {
    Navigator.of(context).pushNamed(NewShoppingListPage.routeName);
  }

  onItemChanged(String value) {
    setState(() {
      viewModel.list = viewModel.filter_list!
          .where((shopping_list) =>
              shopping_list.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //var providerTheme = Provider.of<ProviderTheme>(context);
    final _scaffKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider<HomePageViewModel>(
      create: (context) => viewModel,
      child: Consumer<HomePageViewModel>(
        builder: (context, model, child) => ZoomIn(
          duration: Duration(
            seconds: 1,
          ),
          child: Scaffold(
            key: _scaffKey,
            appBar: AppBar(
              title: Text('Merkar'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(Constant.normalspace),
                  child: Form(
                    key: _key_search,
                    child: SizedBox(
                      height: 30,
                      width: 270,
                      child: TextField(
                        controller: _search_textController,
                        decoration: InputDecoration(
                          labelText: 'Buscar ...',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                        onChanged: onItemChanged,
                      ),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.search), onPressed: () {}),
                /* Switch(
                    value: providerTheme.light,
                    onChanged: (toggle) {
                      providerTheme.updateTheme(toggle);
                      setState(() {
                        // providerTheme.light = toggle;
                        print(
                            "sent a value: ${providerTheme.light} to main.dart");
                        changeTheme();
                        print("Providertheme.ligh = ${providerTheme.light}");
                      });
                    }),*/
                /*  Switch(
                  value: Provider.of<AppStateNotifier>(context).isDarkMode,
                  onChanged: (boolVal) {
                    Provider.of<AppStateNotifier>(context).updateTheme(boolVal);
                  },
                )*/
              ],
            ),
            drawer: DrawerWelcome(),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
                    ]),
                    /* Padding(
                      padding: const EdgeInsets.all(Constant.normalspace),
                      child: Form(
                        key: _key_search,
                        child: SizedBox(
                          height: 30,
                          child: TextField(
                            controller: _search_textController,
                            decoration: InputDecoration(
                              labelText: 'Buscar Actual...',
                              //hintText: ,
                            ),
                            textDirection: TextDirection.ltr,
                            onChanged: onItemChanged,
                          ),
                        ),
                      ),
                    ),*/

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Constant.radiusBorder),
                          topLeft: Radius.circular(Constant.radiusBorder),
                        ),
                        color: Colors.white54,
                      ),
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          (viewModel.list == null)
                              ? Center(child: LoadingWidget())
                              : shoppingListsDisplay(viewModel.list!),
                        ],
                      ),
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
      ),
    );
  }

  void changeTheme() {
    viewModel.changeTheme();
  }
}
