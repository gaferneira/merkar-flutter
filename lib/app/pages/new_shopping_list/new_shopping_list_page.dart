import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import 'new_shopping_list_view_model.dart';

class NewShoppingListPage extends StatefulWidget {
  static const routeName = "/newlist";
  @override
  _NewShoppingListPageState createState() => _NewShoppingListPageState();
}

class _NewShoppingListPageState extends State<NewShoppingListPage> {
  NewShoppingListViewModel viewModel =
      serviceLocator<NewShoppingListViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewShoppingListViewModel>(
      create: (context) => viewModel,
      child: Consumer<NewShoppingListViewModel>(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text('Create new list'),
            ),
            body: RaisedButton(
              child: Text('Save'),
              onPressed: () {
                viewModel.saveList("test", context);
              },
            )),
      ),
    );
  }
}
