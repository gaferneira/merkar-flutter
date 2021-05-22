import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/pages/home/widgets/shopping_lists_display.dart';
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

  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  void _goToCreateList(BuildContext context) async {
    newShoppingListDialog(context, (value) {
      viewModel.saveList(value, context);
    });
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
                pinned: true,
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
                  : shoppingListsDisplay(viewModel.list!, _onRemoveItem),
            ],
          ),
        ),
      ),
    );
  }

  void _onRemoveItem(int index) {
    viewModel.removeList(index);
  }
}
