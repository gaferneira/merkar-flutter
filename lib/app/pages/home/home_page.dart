import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/core/provider_theme.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/app/theme/app_state_notifier.dart';
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
  bool _light = true;
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
    int cursorPos = _search_textController.selection.base.offset;
/*    _search_textController.selection = TextSelection(
        baseOffset: cursorPos + value.length,
        extentOffset: cursorPos + value.length);*/
    setState(() {
      viewModel.list = viewModel.filter_list
          .where((shopping_list) =>
              shopping_list.name.toLowerCase().contains(value.toLowerCase()))
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
        builder: (context, model, child) => Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            title: Text('Merkar ${ProviderTheme().light}'),
            actions: <Widget>[
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
                        // color: Colors.black,
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(Constant.normalspace),
                    child: Form(
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: _search_textController,
                          decoration: InputDecoration(
                            labelText: 'Buscar ...',
                            //hintText: ,
                          ),
                          onChanged: onItemChanged,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
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

  void changeTheme() {
    viewModel.changeTheme();
  }
}
