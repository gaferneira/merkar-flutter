import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/pages/shopping/shopping_list/shopping_list_page.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/widgets.dart';
import '../../../injection_container.dart';
import '../../core/resources/strings.dart';
import '../shopping//new_shopping_list/new_shopping_list_page.dart';
import 'home_view_model.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel = serviceLocator<HomePageViewModel>();

  //bool _light = true;

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
          .where((shoppingList) =>
              shoppingList.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //var providerTheme = Provider.of<ProviderTheme>(context);
    final _scaffKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider<HomePageViewModel>.value(
      value: viewModel,
      child: Consumer<HomePageViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffKey,
          /*appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 50.0,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.white70, Colors.white70],

                // colors: [Colors.cyan[300], Colors.cyan[800]]
              )),
              child: ZoomIn(
                duration: Duration(
                  seconds: 1,
                ),
                child: Image.asset(
                  'assets/images/market.png',
                  width: 10.0,
                ),
              ),
            ),
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
           */

          body: CustomScrollView(
            slivers:[
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 160.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(Strings.label_name_app),
                  background: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  )
                ),
              ),
             const SliverToBoxAdapter(child: SizedBox(height: 30.0,)),
              (viewModel.list == null)
                  ? SliverFillRemaining(child: Center(child: LoadingWidget()))
                  : shoppingListsDisplayItems(viewModel.list!),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "new_list",
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

  Widget shoppingListsDisplayItems(List<ShoppingList> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                color: index.isOdd ? Colors.white : Colors.black12,
                height: 100.0,
                child: ListTile(
                  title: Text(list[index].name!.capitalize()),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ShoppingListPage.routeName,
                      arguments: list[index],
                    );
                  },
                ),
              );
        },
        childCount: list.length,
      ),
    );
  }
}
