import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/shopping_lists_display.dart';
import 'package:provider/provider.dart';

import '../../../app/widgets/widgets.dart';
import '../../../injection_container.dart';
import '../../core/resources/strings.dart';
import 'home_view_model.dart';
import 'widgets/new_shopping_list_dialog.dart';
import 'widgets/sliver_fab.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel = serviceLocator<HomePageViewModel>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  void _goToCreateList(BuildContext context) async {
    newShoppingListDialog(context, _saveNewItem);
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider<HomePageViewModel>.value(
      value: viewModel,
      child: Consumer<HomePageViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffoldKey,
          body: new SliverContainer(
            floatingActionButton: FloatingActionButton(
              heroTag: "new_list",
              onPressed: () => _goToCreateList(context),
              tooltip: Strings.label_tootip_new_list,
              child: Icon(Icons.add),
            ),
            expandedHeight: 256.0,
            slivers: <Widget>[
              new SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                expandedHeight: 256.0,
                pinned: false,
                flexibleSpace: new FlexibleSpaceBar(
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/app_logo.png',
                        fit: BoxFit.fitHeight,
                        height: 35,
                        width: 35,
                      ),
                      Text(Strings.label_name_app),
                    ],
                  ),
                  background: SizedBox(),
                ),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(
                height: 30.0,
              )),
              (viewModel.list == null)
                  ? SliverFillRemaining(child: Center(child: LoadingWidget()))
                  : shoppingListsDisplay(context, viewModel.list!,_onRemoveItem, _onUpdateName, _onCopyShoppingList,_onShareShoppingList),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNewItem(String value) {
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
    } else
    viewModel.saveList(value, context);
  }

  void _onUpdateName(List<String> value) {
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
    } else
      viewModel.updateNameList(value).then((value) => null);
  }


  void _onRemoveItem(int index) {
    viewModel.removeList(index);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(Strings.deleted)));
  }

  void _onCopyShoppingList(int index){
    viewModel.copyShoppingList(index);
  }

  void _onShareShoppingList(int index){
    viewModel.shareShoppingList(index);
  }
}
