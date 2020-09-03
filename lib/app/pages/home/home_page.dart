import 'package:flutter/material.dart';
import 'package:merkar/app/pages/home/home_view_model.dart';
import 'package:merkar/app/pages/home/widgets/shopping_lists_display.dart';
import 'package:merkar/app/pages/new_shopping_list/new_shopping_list_page.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => NewShoppingListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageViewModel>(
      create: (context) => viewModel,
      child: Consumer<HomePageViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('Merkar'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (viewModel.list == null)
                  ? Center(child: LoadingWidget())
                  : shoppingListsDisplay(viewModel.list),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _goToCreateList,
            tooltip: 'New Shopping List',
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
