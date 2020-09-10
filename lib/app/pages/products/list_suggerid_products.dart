import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import 'new_shopping_list_view_model.dart';

class NewShoppingListPage extends StatefulWidget {
  static const routeName = "/newlist";

  @override
  _NewShoppingListPageState createState() => _NewShoppingListPageState();
}

class _NewShoppingListPageState extends State<NewShoppingListPage> {
  String nameList;
  final formListKey = GlobalKey<FormState>();

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
            title: Text(Constant.label_create_new_list),
          ),
          body: _fromNewList(viewModel, context),
        ),
      ),
    );
  }

  Widget _fromNewList(
      NewShoppingListViewModel viewModel, BuildContext context) {
    return Form(
      key: formListKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "Nombre de la lista"),
              onSaved: (value) {
                nameList = value;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene este campo";
                }
                return null;
              },
            ),
            RaisedButton(
              child: Text(Constant.label_save),
              onPressed: () {
                _saveNewList(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _saveNewList(BuildContext context) {
    if (formListKey.currentState.validate()) {
      formListKey.currentState.save();
      viewModel.saveList(nameList, context);
    }
  }
}
